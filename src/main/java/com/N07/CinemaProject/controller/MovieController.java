package com.N07.CinemaProject.controller;

import com.N07.CinemaProject.entity.Movie;
import com.N07.CinemaProject.entity.Screening;
import com.N07.CinemaProject.service.MovieService;
import com.N07.CinemaProject.service.ScreeningService;
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
    private ScreeningService screeningService;
    
    @GetMapping("/{id}")
    public String movieDetail(@PathVariable Long id, Model model, HttpServletRequest request) {
        model.addAttribute("currentPath", request.getRequestURI());
        try {
            Movie movie = movieService.getMovieById(id).orElse(null);
            if (movie == null) {
                return "redirect:/movies";
            }
            
            List<Screening> screenings = screeningService.getScreeningsByMovie(id);
            
            model.addAttribute("movie", movie);
            model.addAttribute("screenings", screenings);
            
            return "pages/movie-detail";
        } catch (Exception e) {
            return "redirect:/movies";
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
