package com.N07.CinemaProject.service;

import java.util.Map;

public class GoogleOAuth2UserInfo extends OAuth2UserInfo {

    public GoogleOAuth2UserInfo(Map<String, Object> attributes) {
        super(attributes);
    }

    @Override
    public String getId() {
        return (String) attributes.get("id");
    }

    @Override
    public String getName() {
        return (String) attributes.get("name");
    }

    @Override
    public String getEmail() {
        return (String) attributes.get("email");
    }

    @Override
    public String getImageUrl() {
        return (String) attributes.get("picture");
    }

    public String getGivenName() {
        return (String) attributes.get("given_name");
    }

    public String getFamilyName() {
        return (String) attributes.get("family_name");
    }

    public Boolean getVerifiedEmail() {
        return (Boolean) attributes.get("verified_email");
    }

    public String getLocale() {
        return (String) attributes.get("locale");
    }
}
