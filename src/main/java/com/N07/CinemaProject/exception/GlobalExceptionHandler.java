package com.N07.CinemaProject.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Xử lý lỗi multipart file upload
     */
    @ExceptionHandler(MultipartException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleMultipartException(MultipartException ex, 
                                         HttpServletRequest request, 
                                         RedirectAttributes redirectAttributes) {
        logger.error("Multipart exception occurred: {}", ex.getMessage(), ex);
        
        // Lấy URL trước đó
        String referer = request.getHeader("Referer");
        
        if (ex.getCause() instanceof org.apache.tomcat.util.http.fileupload.impl.FileCountLimitExceededException) {
            redirectAttributes.addFlashAttribute("error", 
                "Quá nhiều file được upload cùng lúc. Vui lòng thử lại với ít file hơn.");
        } else if (ex instanceof MaxUploadSizeExceededException) {
            redirectAttributes.addFlashAttribute("error", 
                "File upload quá lớn. Vui lòng chọn file nhỏ hơn 10MB.");
        } else {
            redirectAttributes.addFlashAttribute("error", 
                "Có lỗi xảy ra khi upload file. Vui lòng thử lại.");
        }
        
        // Redirect về trang trước đó hoặc trang chủ
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        
        return "redirect:/";
    }

    /**
     * Xử lý lỗi MaxUploadSizeExceededException
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleMaxUploadSizeExceededException(MaxUploadSizeExceededException ex,
                                                     HttpServletRequest request,
                                                     RedirectAttributes redirectAttributes) {
        logger.error("File size exceeded: {}", ex.getMessage(), ex);
        
        String referer = request.getHeader("Referer");
        redirectAttributes.addFlashAttribute("error", 
            "File upload quá lớn. Kích thước tối đa cho phép là 10MB.");
        
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        
        return "redirect:/";
    }

    /**
     * Xử lý các lỗi chung khác
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGeneralException(Exception ex, 
                                       HttpServletRequest request, 
                                       Model model) {
        logger.error("Unexpected error occurred: {}", ex.getMessage(), ex);
        
        model.addAttribute("error", "Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.");
        model.addAttribute("errorDetails", ex.getMessage());
        
        return "error/500";
    }
}
