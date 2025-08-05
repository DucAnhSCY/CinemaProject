package com.N07.CinemaProject.service;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Service
public class DatabaseMonitoringService {
    
    @Autowired
    private DataSource dataSource;
    
    /**
     * Monitor for long-running transactions that might cause deadlocks
     * Runs every 2 minutes during peak hours
     */
    @Scheduled(fixedRate = 120000) // 2 minutes
    public void monitorTransactions() {
        try (Connection connection = dataSource.getConnection()) {
            // Query to check for blocking processes in SQL Server
            String sql = """
                SELECT 
                    blocking_session_id,
                    session_id,
                    wait_type,
                    wait_time,
                    wait_resource
                FROM sys.dm_exec_requests 
                WHERE blocking_session_id <> 0
                """;
            
            try (PreparedStatement stmt = connection.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    int blockingSessionId = rs.getInt("blocking_session_id");
                    int sessionId = rs.getInt("session_id");
                    String waitType = rs.getString("wait_type");
                    long waitTime = rs.getLong("wait_time");
                    String waitResource = rs.getString("wait_resource");
                    
                    if (waitTime > 5000) { // Log if waiting more than 5 seconds
                        System.out.println("🚨 BLOCKING DETECTED: Session " + blockingSessionId + 
                                         " is blocking session " + sessionId + 
                                         " for " + waitTime + "ms on " + waitResource + 
                                         " (Wait type: " + waitType + ")");
                    }
                }
            }
        } catch (SQLException e) {
            // Don't log this as error since it's monitoring
            System.out.println("⚠️ Database monitoring query failed: " + e.getMessage());
        }
    }
    
    /**
     * Clean up old seat holds more aggressively during peak hours
     */
    @Scheduled(fixedRate = 60000) // 1 minute
    public void forceCleanupStaleHolds() {
        try (Connection connection = dataSource.getConnection()) {
            // Force cleanup of holds that are older than their expiry time
            String sql = "DELETE FROM seat_holds WHERE expires_at < DATEADD(minute, -1, GETDATE())";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                int deletedCount = stmt.executeUpdate();
                if (deletedCount > 0) {
                    System.out.println("🧹 Cleaned up " + deletedCount + " stale seat holds");
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ Error cleaning up stale holds: " + e.getMessage());
        }
    }
}
