package com.N07.CinemaProject.service;

import com.N07.CinemaProject.entity.Movie;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@Service
public class TmdbService {
    
    private final WebClient webClient;
    private final ObjectMapper objectMapper;
    
    @Value("${tmdb.api.key:346751e468175d6e62f4836f598c1b67}")
    private String apiKey;
    
    @Value("${tmdb.api.token:eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNDY3NTFlNDY4MTc1ZDZlNjJmNDgzNmY1OThjMWI2NyIsIm5iZiI6MTc1MTYzOTk4MC4zMDcwMDAyLCJzdWIiOiI2ODY3ZTdhY2VhN2FhYzU4OGM1ZTM4NGMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.yqXmMRZX5iRs02qGUnSRRdt3b5QBLS0cVjMcpzY8l8c}")
    private String accessToken;
    
    private static final String TMDB_BASE_URL = "https://api.themoviedb.org/3";
    private static final String IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500";
    private static final String BACKDROP_BASE_URL = "https://image.tmdb.org/t/p/w1280";
    
    public TmdbService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder
                .baseUrl(TMDB_BASE_URL)
                .build();
        this.objectMapper = new ObjectMapper();
    }
    
    public List<Movie> fetchPopularMovies() {
        try {
            String response = webClient.get()
                    .uri("/movie/popular?api_key=" + apiKey + "&language=vi-VN&page=1")
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMoviesFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<Movie> fetchNowPlayingMovies() {
        try {
            String response = webClient.get()
                    .uri("/movie/now_playing?api_key=" + apiKey + "&language=vi-VN&page=1")
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMoviesFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Movie fetchMovieDetails(Long tmdbId) {
        try {
            String response = webClient.get()
                    .uri("/movie/" + tmdbId + "?api_key=" + apiKey + "&language=vi-VN")
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMovieFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public List<Movie> searchMovies(String query) {
        try {
            String response = webClient.get()
                    .uri("/search/movie?query=" + query + "&api_key=" + apiKey + "&language=vi-VN&page=1")
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMoviesFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<Movie> searchMovies(String query, Integer year) {
        try {
            StringBuilder uriBuilder = new StringBuilder("/search/movie?query=").append(query).append("&api_key=").append(apiKey).append("&language=vi-VN&page=1");
            if (year != null && year > 1900 && year <= LocalDate.now().getYear() + 2) {
                uriBuilder.append("&year=").append(year);
            }
            
            String response = webClient.get()
                    .uri(uriBuilder.toString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMoviesFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<Movie> discoverMoviesByYear(Integer year) {
        try {
            StringBuilder uriBuilder = new StringBuilder("/discover/movie?api_key=").append(apiKey).append("&language=vi-VN&page=1&sort_by=popularity.desc");
            if (year != null && year > 1900 && year <= LocalDate.now().getYear() + 2) {
                uriBuilder.append("&year=").append(year);
            }
            
            String response = webClient.get()
                    .uri(uriBuilder.toString())
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            
            return parseMoviesFromResponse(response);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    private List<Movie> parseMoviesFromResponse(String response) {
        List<Movie> movies = new ArrayList<>();
        try {
            JsonNode rootNode = objectMapper.readTree(response);
            JsonNode resultsNode = rootNode.get("results");
            
            if (resultsNode != null && resultsNode.isArray()) {
                for (JsonNode movieNode : resultsNode) {
                    Movie movie = parseMovieFromNode(movieNode);
                    if (movie != null) {
                        movies.add(movie);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return movies;
    }
    
    private Movie parseMovieFromResponse(String response) {
        try {
            JsonNode movieNode = objectMapper.readTree(response);
            return parseMovieFromNode(movieNode);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private Movie parseMovieFromNode(JsonNode movieNode) {
        try {
            Movie movie = new Movie();
            
            // Basic Information
            movie.setTmdbId(movieNode.get("id").asLong());
            movie.setTitle(movieNode.has("title") ? movieNode.get("title").asText() : "");
            movie.setOriginalTitle(movieNode.has("original_title") ? movieNode.get("original_title").asText() : "");
            movie.setDescription(movieNode.has("overview") ? movieNode.get("overview").asText() : "");
            movie.setOriginalLanguage(movieNode.has("original_language") ? movieNode.get("original_language").asText() : "");
            
            // Ratings and Popularity
            movie.setVoteAverage(movieNode.has("vote_average") ? movieNode.get("vote_average").asDouble() : 0.0);
            movie.setVoteCount(movieNode.has("vote_count") ? movieNode.get("vote_count").asInt() : 0);
            movie.setPopularity(movieNode.has("popularity") ? movieNode.get("popularity").asDouble() : 0.0);
            movie.setAdult(movieNode.has("adult") ? movieNode.get("adult").asBoolean() : false);
            
            // Release Date
            if (movieNode.has("release_date") && !movieNode.get("release_date").isNull()) {
                String releaseDateStr = movieNode.get("release_date").asText();
                if (!releaseDateStr.isEmpty()) {
                    try {
                        movie.setReleaseDate(LocalDate.parse(releaseDateStr, DateTimeFormatter.ISO_LOCAL_DATE));
                    } catch (DateTimeParseException e) {
                        movie.setReleaseDate(LocalDate.now());
                    }
                }
            } else {
                movie.setReleaseDate(LocalDate.now());
            }
            
            // Images
            if (movieNode.has("poster_path") && !movieNode.get("poster_path").isNull()) {
                String posterPath = movieNode.get("poster_path").asText();
                movie.setPosterUrl(IMAGE_BASE_URL + posterPath);
            }
            
            if (movieNode.has("backdrop_path") && !movieNode.get("backdrop_path").isNull()) {
                String backdropPath = movieNode.get("backdrop_path").asText();
                movie.setBackdropUrl(BACKDROP_BASE_URL + backdropPath);
            }
            
            // Genres (for detailed movie info)
            if (movieNode.has("genres") && movieNode.get("genres").isArray()) {
                StringBuilder genreBuilder = new StringBuilder();
                JsonNode genresNode = movieNode.get("genres");
                for (int i = 0; i < genresNode.size(); i++) {
                    if (i > 0) genreBuilder.append(", ");
                    genreBuilder.append(genresNode.get(i).get("name").asText());
                }
                movie.setGenre(genreBuilder.toString());
            } else if (movieNode.has("genre_ids") && movieNode.get("genre_ids").isArray()) {
                // For search results, we get genre IDs instead of names
                movie.setGenre(mapGenreIds(movieNode.get("genre_ids")));
            }
            
            // Runtime (for detailed movie info)
            if (movieNode.has("runtime") && !movieNode.get("runtime").isNull()) {
                movie.setDurationMin(movieNode.get("runtime").asInt());
            }
            
            return movie;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private String mapGenreIds(JsonNode genreIds) {
        // TMDB Genre IDs mapping
        StringBuilder genres = new StringBuilder();
        for (JsonNode idNode : genreIds) {
            int id = idNode.asInt();
            String genre = getGenreNameById(id);
            if (!genre.isEmpty()) {
                if (genres.length() > 0) genres.append(", ");
                genres.append(genre);
            }
        }
        return genres.toString();
    }
    
    private String getGenreNameById(int genreId) {
        return switch (genreId) {
            case 28 -> "Action";
            case 12 -> "Adventure";
            case 16 -> "Animation";
            case 35 -> "Comedy";
            case 80 -> "Crime";
            case 99 -> "Documentary";
            case 18 -> "Drama";
            case 10751 -> "Family";
            case 14 -> "Fantasy";
            case 36 -> "History";
            case 27 -> "Horror";
            case 10402 -> "Music";
            case 9648 -> "Mystery";
            case 10749 -> "Romance";
            case 878 -> "Science Fiction";
            case 10770 -> "TV Movie";
            case 53 -> "Thriller";
            case 10752 -> "War";
            case 37 -> "Western";
            default -> "";
        };
    }
}
