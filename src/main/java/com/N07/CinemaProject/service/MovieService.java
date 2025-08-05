package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class MovieService {
    
    @Autowired
    private MovieRepository movieRepository;
    
    @Autowired
    private TmdbService tmdbService;
    
    @Cacheable("movies")
    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }
    
    @Cacheable(value = "movies", key = "#id")
    public Optional<Movie> getMovieById(Long id) {
        return movieRepository.findById(id);
    }
    
    @Transactional
    @Cacheable(value = "movies", key = "'currently-showing'")
    public List<Movie> getCurrentlyShowingMovies() {
        // First, try to get movies from database
        List<Movie> dbMovies = movieRepository.findCurrentlyShowingMovies(LocalDate.now());
        
        // If no movies in database or less than 10, fetch from TMDB
        if (dbMovies.size() < 10) {
            List<Movie> tmdbMovies = tmdbService.fetchNowPlayingMovies();
            
            // Save new movies to database if they don't exist
            for (Movie tmdbMovie : tmdbMovies) {
                Optional<Movie> existingMovie = movieRepository.findByTmdbId(tmdbMovie.getTmdbId());
                if (existingMovie.isEmpty()) {
                    movieRepository.save(tmdbMovie);
                    dbMovies.add(tmdbMovie);
                }
            }
        }
        
        return dbMovies;
    }
    
    @Transactional
    @Cacheable(value = "popularMovies", key = "'all'")
    public List<Movie> getPopularMovies() {
        // Kiểm tra database trước, nếu đã có đủ phim thì không cần gọi TMDB
        List<Movie> existingMovies = movieRepository.findAll();
        if (!existingMovies.isEmpty() && existingMovies.size() >= 20) {
            System.out.println("Using existing movies from database (" + existingMovies.size() + " movies)");
            return existingMovies.stream()
                    .limit(20)
                    .collect(Collectors.toList());
        }
        
        return forceRefreshMovies();
    }
    
    @Transactional
    @CacheEvict(value = {"popularMovies", "movies"}, allEntries = true)
    public List<Movie> forceRefreshMovies() {
        System.out.println("Fetching movies from TMDB API...");
        List<Movie> tmdbMovies = tmdbService.fetchPopularMovies();
        
        // Save or update movies in database
        for (Movie tmdbMovie : tmdbMovies) {
            Optional<Movie> existingMovie = movieRepository.findByTmdbId(tmdbMovie.getTmdbId());
            if (existingMovie.isPresent()) {
                // Update existing movie with latest TMDB data
                Movie existing = existingMovie.get();
                updateMovieFromTmdb(existing, tmdbMovie);
                movieRepository.save(existing);
            } else {
                // Save new movie
                movieRepository.save(tmdbMovie);
            }
        }
        
        return movieRepository.findAll().stream()
                .limit(20)
                .collect(Collectors.toList());
    }
    
    public List<Movie> searchMoviesByTitle(String title) {
        // First search in database
        List<Movie> dbResults = movieRepository.findByTitleContainingIgnoreCase(title);
        
        // If limited results, also search TMDB
        if (dbResults.size() < 5) {
            List<Movie> tmdbResults = tmdbService.searchMovies(title);
            
            // Add new movies from TMDB to database and results
            for (Movie tmdbMovie : tmdbResults) {
                Optional<Movie> existingMovie = movieRepository.findByTmdbId(tmdbMovie.getTmdbId());
                if (existingMovie.isEmpty()) {
                    Movie savedMovie = movieRepository.save(tmdbMovie);
                    dbResults.add(savedMovie);
                }
            }
        }
        
        return dbResults;
    }
    
    public List<Movie> getMoviesByGenre(String genre) {
        return movieRepository.findByGenreContainingIgnoreCase(genre);
    }
    
    @CacheEvict(value = {"movies", "popularMovies", "screenings"}, allEntries = true)
    public Movie saveMovie(Movie movie) {
        System.out.println("Saving movie and clearing cache...");
        return movieRepository.save(movie);
    }
    
    @CacheEvict(value = {"movies", "popularMovies", "screenings"}, allEntries = true)
    public void deleteMovie(Long id) {
        System.out.println("Deleting movie and clearing cache...");
        movieRepository.deleteById(id);
    }
    
    @CacheEvict(value = {"movies", "popularMovies", "screenings", "activeScreenings"}, allEntries = true)
    public void clearAllCache() {
        System.out.println("Clearing all movie and screening caches...");
    }
    
    public void deleteAllMovies() {
        movieRepository.deleteAll();
    }
    
    public List<Movie> searchMovies(String title, String genre) {
        if (title != null && genre != null) {
            // Search by both title and genre
            return movieRepository.findByTitleContainingIgnoreCaseAndGenreContainingIgnoreCase(title, genre);
        } else if (title != null) {
            return searchMoviesByTitle(title);
        } else if (genre != null) {
            return getMoviesByGenre(genre);
        } else {
            return getCurrentlyShowingMovies();
        }
    }
    
    @Transactional
    public Movie getOrCreateMovieByTmdbId(Long tmdbId) {
        try {
            // First check if movie already exists
            Optional<Movie> existingMovie = movieRepository.findByTmdbId(tmdbId);
            if (existingMovie.isPresent()) {
                return existingMovie.get();
            }
            
            // Fetch from TMDB and save
            Movie tmdbMovie = tmdbService.fetchMovieDetails(tmdbId);
            if (tmdbMovie != null) {
                // Make sure the tmdbId is set
                tmdbMovie.setTmdbId(tmdbId);
                return movieRepository.save(tmdbMovie);
            }
            
            return null;
        } catch (Exception e) {
            // Handle duplicate key constraint violations
            if (e.getMessage() != null && e.getMessage().contains("duplicate key")) {
                // If there's a constraint violation, try to fetch the existing movie again
                Optional<Movie> existingMovie = movieRepository.findByTmdbId(tmdbId);
                return existingMovie.orElse(null);
            }
            throw e;
        }
    }
    
    private void updateMovieFromTmdb(Movie existing, Movie tmdbMovie) {
        existing.setTitle(tmdbMovie.getTitle());
        existing.setDescription(tmdbMovie.getDescription());
        existing.setOverview(tmdbMovie.getOverview());  // Thêm overview
        existing.setPosterUrl(tmdbMovie.getPosterUrl());
        existing.setBackdropUrl(tmdbMovie.getBackdropUrl());
        existing.setVoteAverage(tmdbMovie.getVoteAverage());
        existing.setVoteCount(tmdbMovie.getVoteCount());
        existing.setPopularity(tmdbMovie.getPopularity());
        existing.setGenre(tmdbMovie.getGenre());
        existing.setDurationMin(tmdbMovie.getDurationMin());
        existing.setOriginalTitle(tmdbMovie.getOriginalTitle());
        existing.setOriginalLanguage(tmdbMovie.getOriginalLanguage());
        existing.setAdult(tmdbMovie.getAdult());
    }
}
