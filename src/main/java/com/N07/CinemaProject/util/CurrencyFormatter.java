package com.N07.CinemaProject.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class CurrencyFormatter {
    
    private static final DecimalFormat VND_FORMAT;
    
    static {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.forLanguageTag("vi-VN"));
        symbols.setGroupingSeparator(',');
        symbols.setDecimalSeparator('.');
        
        VND_FORMAT = new DecimalFormat("#,##0", symbols);
    }
    
    /**
     * Format amount to VND currency string
     * Example: 204000 -> "204,000 VND"
     */
    public static String formatVND(BigDecimal amount) {
        if (amount == null) {
            return "0 VND";
        }
        return VND_FORMAT.format(amount) + " VND";
    }
    
    /**
     * Format amount to VND currency string
     * Example: 204000.0 -> "204,000 VND"
     */
    public static String formatVND(Double amount) {
        if (amount == null) {
            return "0 VND";
        }
        return VND_FORMAT.format(amount) + " VND";
    }
    
    /**
     * Format amount to VND currency string
     * Example: 204000 -> "204,000 VND"
     */
    public static String formatVND(Long amount) {
        if (amount == null) {
            return "0 VND";
        }
        return VND_FORMAT.format(amount) + " VND";
    }
    
    /**
     * Format amount without VND suffix
     * Example: 204000 -> "204,000"
     */
    public static String formatNumber(BigDecimal amount) {
        if (amount == null) {
            return "0";
        }
        return VND_FORMAT.format(amount);
    }
}
