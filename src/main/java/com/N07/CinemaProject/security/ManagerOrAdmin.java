package com.N07.CinemaProject.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation để đánh dấu các method/controller chỉ dành cho Manager và Admin
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ManagerOrAdmin {
    String message() default "Chỉ quản lý rạp hoặc quản trị viên mới có thể thực hiện hành động này";
}
