package com.N07.CinemaProject.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.BatchSize;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "movies", uniqueConstraints = {
    @UniqueConstraint(columnNames = "tmdb_id", name = "IX_movies_tmdb_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"screenings"})
public class Movie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(name = "duration_min")
    private Integer durationMin;
    
    private String genre;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "release_date")
    private LocalDate releaseDate;
    
    @Column(name = "poster_url")
    private String posterUrl;
    
    // TMDB Integration Fields
    @Column(name = "tmdb_id")
    private Long tmdbId;
    
    @Column(name = "backdrop_url")
    private String backdropUrl;
    
    @Column(name = "original_language")
    private String originalLanguage;
    
    @Column(name = "vote_average")
    private Double voteAverage;
    
    @Column(name = "vote_count")
    private Integer voteCount;
    
    @Column(name = "popularity")
    private Double popularity;
    
    @Column(name = "original_title")
    private String originalTitle;
    
    @Column(name = "adult")
    private Boolean adult;
    
    // Additional movie information fields
    @Column(name = "director")
    private String director;
    
    @Column(name = "cast", columnDefinition = "TEXT")
    private String cast;
    
    @Column(name = "country")
    private String country;
    
    @Column(name = "language")
    private String language;
    
    @Column(name = "overview", columnDefinition = "TEXT")
    private String overview;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @Column(name = "rating")
    private String rating;
    
    @JsonIgnore
    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @BatchSize(size = 10)
    private List<Screening> screenings;
}
