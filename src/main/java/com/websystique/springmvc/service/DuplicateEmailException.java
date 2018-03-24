package com.websystique.springmvc.service;

public class DuplicateEmailException  extends Exception {
    public DuplicateEmailException(String message) {
        super(message);
    }
}
