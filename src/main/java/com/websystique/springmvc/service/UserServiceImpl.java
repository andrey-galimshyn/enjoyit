package com.websystique.springmvc.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
 
import com.websystique.springmvc.dao.UserDao;
import com.websystique.springmvc.dto.RegistrationForm;
import com.websystique.springmvc.model.User;
import com.websystique.springmvc.model.UserProfile;
 
 
@Service("userService")
@Transactional
public class UserServiceImpl implements UserService{
 
    @Autowired
    private UserDao dao;
 
    public User findById(int id) {
        return dao.findById(id);
    }
 
    public User findBySSO(String sso) {
        User user = dao.findBySSO(sso);
        return user;
    }

	@Override
	public User findByEmail(String email) {
        User user = dao.findByEmail(email);
        return user;
	}

    public void saveUser(User user) {
        dao.save(user);
    }
 
    /*
     * Since the method is running with Transaction, No need to call hibernate update explicitly.
     * Just fetch the entity from db and update it with proper values within transaction.
     * It will be updated in db once transaction ends. 
     */
    public void updateUser(User user) {
        User entity = dao.findById(user.getId());
        if(entity!=null){
            entity.setSsoid(user.getSsoid());
            entity.setPassword(user.getPassword());
            entity.setFirstName(user.getFirstName());
            entity.setLastName(user.getLastName());
            entity.setEmail(user.getEmail());
            entity.setUserProfiles(user.getUserProfiles());
        }
    }
 
     
    public void deleteUserBySSO(String sso) {
        dao.deleteBySSO(sso);
    }
 
    public List<User> findAllUsers() {
        return dao.findAllUsers();
    }
 
    public boolean isUserSSOUnique(Integer id, String sso) {
        User user = findBySSO(sso);
        return ( user == null || ((id != null) && (user.getId() == id)));
    }
     
    @Transactional
    @Override
    public User registerNewUserAccount(RegistrationForm userAccountData, UserProfile userProfile) throws DuplicateEmailException {

        if (emailExist(userAccountData.getEmail())) {
            throw new DuplicateEmailException("The email address: " + userAccountData.getEmail() + " is already in use.");
        }


        User registered = new User();
        registered.setEmail(userAccountData.getEmail());
        registered.setFirstName(userAccountData.getFirstName());
        registered.setLastName(userAccountData.getLastName());
        registered.setPassword(userAccountData.getPassword());
        registered.setSsoid(userAccountData.getSsoid());
        Set<UserProfile> userProfiles = new HashSet<UserProfile>();
        userProfiles.add(userProfile);
        registered.setUserProfiles(userProfiles);


        if (userAccountData.isSocialSignIn()) {
        	registered.setSignInProvider(userAccountData.getSignInProvider());
        }

        dao.save(registered);
        
        return registered;
    }
    
    
    private boolean emailExist(String email) {

        User user = dao.findByEmail(email);

        if (user != null) {
            return true;
        }

        return false;
    }




}