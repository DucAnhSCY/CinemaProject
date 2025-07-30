package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.SingleCinemaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/movies")
public class MovieController {
    
    @Autowired
    private MovieService movieService;
    
    @Autowired
    private SingleCinemaService singleCinemaService;
    
    @GetMapping("/{id}")
    public String movieDetail(@PathVariable Long id, Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            Movie movie = movieService.getMovieById(id).orElse(null);
            if (movie == null) {
                model.addAttribute("movie", null);
                model.addAttribute("screenings", List.of());
                return "pages/movie-detail";
            }
            
            // Use SingleCinemaService to get screenings efficiently without N+1 queries
            List<Screening> screenings = singleCinemaService.getScreeningsByMovie(movie);
            
            model.addAttribute("movie", movie);
            model.addAttribute("screenings", screenings);
            
            return "pages/movie-detail";
        } catch (Exception e) {
            // Log the error for debugging
            System.err.println("Error in movieDetail: " + e.getMessage());
            e.printStackTrace();
            
            // Set null movie to trigger the error page in template
            model.addAttribute("movie", null);
            model.addAttribute("screenings", List.of());
            return "pages/movie-detail";
        }
    }
    
    @GetMapping
    public String allMovies(Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            List<Movie> movies = movieService.getAllMovies();
            model.addAttribute("movies", movies);
        } catch (Exception e) {
            model.addAttribute("movies", List.of());
        }
        return "pages/movies";
    }
}
