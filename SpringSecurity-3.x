<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-validation</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
		<dependency>
			<groupId>com.h2database</groupId>
			<artifactId>h2</artifactId>
			<scope>runtime</scope>
		</dependency>
		<dependency>
			<groupId>org.projectlombok</groupId>
			<artifactId>lombok</artifactId>
			<optional>true</optional>
		</dependency>
<dependencies>
-------------------------application.yml----------------------------------------------------------------------
server:
  port: 8080
spring:
  application:
    name: spring-security-jwt-3.x
  datasource:
    url: jdbc:h2:mem:dev
    username: dev
    password:
    driverClassName:
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    show_sql: true
    format_sql: true
    hibernate:
      -auto: update
  h2:
    console:
      enabled: true
      path: /h2
-------------------------SpringSecurityJWTApplication.java----------------------------------------------------------------------
package com.cts.spring;

import com.cts.spring.entity.AuthUserEntity;
import com.cts.spring.entity.EmployeeEntity;
import com.cts.spring.repository.AuthUserRepository;
import com.cts.spring.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;

@SpringBootApplication
public class SpringSecurityJWTApplication implements ApplicationRunner, CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(SpringSecurityJWTApplication.class, args);
	}

	@Autowired
	private AuthUserRepository authUserRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Override
	public void run(ApplicationArguments args) throws Exception {
		AuthUserEntity e1 = AuthUserEntity.builder().username("user").password(passwordEncoder.encode("user"))
				.roles("ROLE_USER").build();
		AuthUserEntity e2 = AuthUserEntity.builder().username("admin").password(passwordEncoder.encode("admin"))
				.roles("ROLE_ADMIN").build();
		AuthUserEntity e3 = AuthUserEntity.builder().username("mk").password(passwordEncoder.encode("mk"))
				.roles("ROLE_USER, ROLE_ADMIN").build();
		authUserRepository.saveAllAndFlush(List.of(e1,e2,e3));
	}

	@Autowired
	private EmployeeRepository employeeRepository;

	@Override
	public void run(String... args) throws Exception {
		System.out.println("CommandLineRunner:run() method");
		EmployeeEntity e1 = EmployeeEntity.builder().empName("mk").empAddress("bihar").empAge(20).empSalary(12345.9).build();
		EmployeeEntity e2 = EmployeeEntity.builder().empName("pk").empAddress("patna").empAge(23).empSalary(54321).build();
		List<EmployeeEntity> userEntities = List.of(e1,e2,e2);
		userEntities.forEach(emp -> employeeRepository.save(emp));
	}
}
-------------------------SpringSecurityConfig.java----------------------------------------------------------------------
package com.cts.spring.config;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SpringSecurityConfig {
    @Bean
    public UserDetailsService userDetailsService(){
        return new UserDetailsServiceImpl();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/user","/user/*").permitAll()
                        .requestMatchers("/authenticate").permitAll()
                        .requestMatchers("/employee/*").permitAll()
                        .anyRequest().authenticated())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                //.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class); //Bearer Token will use in postman
                .httpBasic(Customizer.withDefaults());  //Basic Auth will use in postman
        return httpSecurity.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationProvider authenticationProvider(){
        DaoAuthenticationProvider daoAuthenticationProvider = new DaoAuthenticationProvider();
        daoAuthenticationProvider.setUserDetailsService(userDetailsService());
        daoAuthenticationProvider.setPasswordEncoder(passwordEncoder());
        return daoAuthenticationProvider;
    }
}
-------------------------UserDetailsServiceImpl.java----------------------------------------------------------------------
package com.cts.spring.config;

import com.cts.spring.entity.AuthUserEntity;
import com.cts.spring.exception.UserRecordNotFoundException;
import com.cts.spring.repository.AuthUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private AuthUserRepository authUserRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        Optional<AuthUserEntity> authUserEntity = authUserRepository.findByUsername(username);
//        if(authUserEntity.isPresent())
//            return new UserDetailsImpl(authUserEntity.get());
//        else
//            throw new UsernameNotFoundException("User not found in auth table");
//   using lembda approach
//        return authUserRepository.findByUsername(username).map(authUserEntity -> new UserDetailsImpl(authUserEntity)).orElseThrow(() ->
//                new UserRecordNotFoundException("User Not found in Auth table"));
//   using method/constructor approach
        return authUserRepository.findByUsername(username).map(UserDetailsImpl::new)
                .orElseThrow(() -> new UserRecordNotFoundException("User Not found in Auth table"));
    }
}
-------------------------UserDetailsImpl.java----------------------------------------------------------------------
package com.cts.spring.config;

import com.cts.spring.entity.AuthUserEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Arrays;
import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

public class UserDetailsImpl implements UserDetails {

    private final String username;
    private final String password;
    private final Set<GrantedAuthority> grantedAuthorities;

    public UserDetailsImpl(AuthUserEntity authUserEntity){
        this.username = authUserEntity.getUsername();
        this.password = authUserEntity.getPassword();
        this.grantedAuthorities = Arrays.stream(authUserEntity.getRoles().split(","))
                //.map(role -> new SimpleGrantedAuthority(role)).collect(Collectors.toSet());
                .map(SimpleGrantedAuthority::new).collect(Collectors.toSet());
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return grantedAuthorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
-------------------------AuthUserRepository.java----------------------------------------------------------------------
package com.cts.spring.repository;
import com.cts.spring.entity.AuthUserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AuthUserRepository extends JpaRepository<AuthUserEntity, Integer> {
    Optional<AuthUserEntity> findByUsername(String userName);
}
-------------------------AuthUserEntity.java----------------------------------------------------------------------
package com.cts.spring.entity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "AUTH_USER")
public class AuthUserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String username;
    private String password;
    private String roles;
}
-------------------------EmployeeRepository.java----------------------------------------------------------------------
package com.cts.spring.repository;
import com.cts.spring.entity.EmployeeEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmployeeRepository extends JpaRepository<EmployeeEntity, Integer> {
}
-------------------------EmployeeEntity.java----------------------------------------------------------------------
package com.cts.spring.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "EMPLOYEE")
public class EmployeeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int empId;
    private String empName;
    private int empAge;
    private String empAddress;
    private double empSalary;
}
-------------------------AuthUserService.java----------------------------------------------------------------------
package com.cts.spring.service;
import com.cts.spring.dto.AuthUserDTO;
import java.util.List;
import java.util.Optional;
public interface AuthUserService {
    AuthUserDTO findByUserName(String userName);
    List<AuthUserDTO> findAll();
    String createAuthUser(AuthUserDTO authUserDTO);
    void deleteById(int userId);
}
-------------------------EmployeeService.java----------------------------------------------------------------------
package com.cts.spring.service;
import com.cts.spring.dto.EmployeeDTO;
import java.util.List;
import java.util.Map;
public interface EmployeeService {
    EmployeeDTO save(EmployeeDTO employeeDTO);
    EmployeeDTO findById(int empId);
    List<EmployeeDTO> findAll();
    void deleteById(int empId);
    EmployeeDTO update(int empId, EmployeeDTO employeeDTO);
    EmployeeDTO partialUpdate(int empId, Map<String,String> mapUpdateProperties);
}
-------------------------AuthUserServiceImpl.java----------------------------------------------------------------------
package com.cts.spring.service.impl;
import com.cts.spring.dto.AuthUserDTO;
import com.cts.spring.entity.AuthUserEntity;
import com.cts.spring.exception.UserRecordNotFoundException;
import com.cts.spring.repository.AuthUserRepository;
import com.cts.spring.service.AuthUserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class AuthUserServiceImpl implements AuthUserService {

    @Autowired
    private AuthUserRepository authUserRepository;

    @Override
    public AuthUserDTO findByUserName(String userName) {
        System.out.println("AuthUserServiceImpl:findByUserName() method "+userName);
        Optional<AuthUserEntity> authUserEntity = authUserRepository.findByUsername(userName);
        if(authUserEntity.isPresent()){
            AuthUserDTO authUserDTO = new AuthUserDTO();
            BeanUtils.copyProperties(authUserEntity.get(), authUserDTO);
            return authUserDTO;
        }else
            throw new UserRecordNotFoundException("User Not Found in Auth User Table, UserName:"+userName);
    }

    @Override
    public List<AuthUserDTO> findAll() {
        System.out.println("AuthUserServiceImpl:findByUserName() method");
        List<AuthUserEntity> authUserEntities = authUserRepository.findAll();
        List<AuthUserDTO> authUserDTOList = new ArrayList<>();
        authUserEntities.forEach(authUserEntity -> {
            AuthUserDTO authUserDTO = new AuthUserDTO();
            BeanUtils.copyProperties(authUserEntity, authUserDTO);
            authUserDTOList.add(authUserDTO);
        });
        return authUserDTOList;
    }

    @Override
    public String createAuthUser(AuthUserDTO authUserDTO) {
        System.out.println("AuthUserServiceImpl:findByUserName() method");
        AuthUserEntity authUserEntity = new AuthUserEntity();
        BeanUtils.copyProperties(authUserDTO, authUserEntity);
        authUserEntity.setPassword(new BCryptPasswordEncoder()
         .encode(authUserEntity.getPassword()));
        return "User Saved Successfully, Username is : "+
                authUserRepository.save(authUserEntity).getUsername();
    }

    @Override
    public void deleteById(int userId) {
        System.out.println("AuthUserServiceImpl:findByUserName() method");
        Optional<AuthUserEntity> authUserEntity = authUserRepository.findById(userId);
        if(authUserEntity.isPresent()){
            authUserRepository.deleteById(userId);
        }else
            throw new UserRecordNotFoundException("User Id Not Found in Auth User Table, Id:"+userId);
    }
}
-------------------------EmployeeServiceImpl.java----------------------------------------------------------------------
package com.cts.spring.service.impl;
import com.cts.spring.dto.EmployeeDTO;
import com.cts.spring.entity.EmployeeEntity;
import com.cts.spring.exception.EmployeeRecordNotFoundException;
import com.cts.spring.repository.EmployeeRepository;
import com.cts.spring.service.EmployeeService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Override
    public EmployeeDTO findById(int empId) {
        System.out.println("EmployeeServiceImpl:findById()");
        Optional<EmployeeEntity> employeeEntity =  employeeRepository.findById(empId);
        if(employeeEntity.isPresent()){
            EmployeeDTO employeeDTO = new EmployeeDTO();
            BeanUtils.copyProperties(employeeEntity.get(), employeeDTO);
            return employeeDTO;
        }else
            throw new EmployeeRecordNotFoundException("Record Not Found");
    }
    @Override
    public List<EmployeeDTO> findAll() {
        System.out.println("EmployeeServiceImpl:findAll()");
        List<EmployeeEntity> employeeEntities = employeeRepository.findAll();
        List<EmployeeDTO> employeeDTOS = new ArrayList<>();
        employeeEntities.forEach(entity -> {
            EmployeeDTO employeeDTO = new EmployeeDTO();
            BeanUtils.copyProperties(entity, employeeDTO);
            employeeDTOS.add(employeeDTO);
        });
        return employeeDTOS;
    }
    @Override
    public void deleteById(int empId) {
        System.out.println("EmployeeServiceImpl:deleteById() method");
        Optional<EmployeeEntity> employeeEntity = employeeRepository.findById(empId);
        if(employeeEntity.isPresent())
            employeeRepository.deleteById(empId);
        else
            throw new EmployeeRecordNotFoundException("Record not found in table, Emp Id : "+empId);
    }
    @Override
    public EmployeeDTO update(int empId, EmployeeDTO employeeDTO) {
        System.out.println("EmployeeServiceImpl:update()");
        Optional<EmployeeEntity> employeeEntity = employeeRepository.findById(empId);
        if(employeeEntity.isPresent()) {
            employeeDTO.setEmpId(empId);
            return save(employeeDTO);
        }
        else
            throw new EmployeeRecordNotFoundException("Record not found in table, Id:"+empId);
    }
    @Override
    public EmployeeDTO partialUpdate(int empId, Map<String,String> mapUpdateProperties) {
        System.out.println("EmployeeServiceImpl:partialUpdate()"+mapUpdateProperties);
        Optional<EmployeeEntity> employeeEntity = employeeRepository.findById(empId);
        if(employeeEntity.isPresent()){
            mapUpdateProperties.forEach((key,value) ->{
                if(key.equals("empAddress"))
                    employeeEntity.get().setEmpAddress(value);
                else if(key.equals("empSalary"))
                    employeeEntity.get().setEmpSalary(Double.parseDouble(value));
            });
            EmployeeDTO employeeDTO = new EmployeeDTO();
            BeanUtils.copyProperties(employeeRepository.save(employeeEntity.get()), employeeDTO);
            return employeeDTO;
        }else
            throw new EmployeeRecordNotFoundException("Record not found in table, Id:"+empId);
    }
    @Override
    public EmployeeDTO save(EmployeeDTO employeeDTO) {
        System.out.println("EmployeeServiceImpl:save()");
        EmployeeEntity employeeEntity = new EmployeeEntity();
        BeanUtils.copyProperties(employeeDTO, employeeEntity);
        BeanUtils.copyProperties(employeeRepository.save(employeeEntity), employeeDTO);
        return employeeDTO;
    }
}
-------------------------GlobalExceptionHandler.java----------------------------------------------------------------------
package com.cts.spring.exception;
import org.springframework.http.HttpStatus;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserRecordNotFoundException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String userNotFoundException(UserRecordNotFoundException ex){
       // return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        return ex.getMessage();
    }

    @ExceptionHandler(EmployeeRecordNotFoundException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String employeeRecordNotFoundException(EmployeeRecordNotFoundException ex){
        // return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        return ex.getMessage();
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, String> methodArgumentNotValidException(MethodArgumentNotValidException ex){
        Map<String, String> map = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            map.put( ((FieldError)error).getField(), error.getDefaultMessage());
        });
        return map;
    }
}
-------------------------EmployeeRecordNotFoundException.java----------------------------------------------------------------------
package com.cts.spring.exception;
public class EmployeeRecordNotFoundException extends RuntimeException {

    public EmployeeRecordNotFoundException() {
        super();
    }
    public EmployeeRecordNotFoundException(String message) {
        super(message);
    }
}
-------------------------UserRecordNotFoundException.java----------------------------------------------------------------------
package com.cts.spring.exception;
public class UserRecordNotFoundException extends RuntimeException{

    public UserRecordNotFoundException(){
        super();
    }
    public UserRecordNotFoundException(String message){
        super(message);
    }
}
-------------------------AuthUserDTO.java----------------------------------------------------------------------
package com.cts.spring.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AuthUserDTO {
    private int id;
    @NotNull
    private String username;
    @NotNull
    private String password;
    @NotNull
    private String roles;
}
-------------------------EmployeeDTO.java----------------------------------------------------------------------
package com.cts.spring.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class EmployeeDTO {

    private int empId;

    @NotNull
    private String empName;

    @NotNull
    private String empAddress;

    @Min(value = 18)
    @Max(value = 50)
    @NotNull
    private int empAge;

    @NotNull
    @DecimalMin("1000.0")
    @DecimalMax("100000.0")
    private double empSalary;
}
-------------------------AuthUserController.java----------------------------------------------------------------------
package com.cts.spring.controller;

import com.cts.spring.config.JWTTokenService;
import com.cts.spring.dto.AuthUserDTO;
import com.cts.spring.exception.UserRecordNotFoundException;
import com.cts.spring.service.AuthUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
public class AuthUserController {

    @Autowired
    private AuthUserService authUserService;

    @Autowired
    private JWTTokenService jwtTokenService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @PostMapping("/authenticate")
    public String authAndGetToken(@RequestBody Map<String, String> mapUserPwd){
        System.out.println("AuthUserController:findByName() method "+mapUserPwd);
        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(mapUserPwd.get("username"),
                        mapUserPwd.get("password")));
        if(authentication.isAuthenticated())
            return jwtTokenService.generateToken(mapUserPwd.get("username"));
        else
            throw new UserRecordNotFoundException("User not found in auth table");
    }
    @GetMapping("/user/{username}")
    public ResponseEntity<AuthUserDTO> findByName(@PathVariable("username") String userName){
        System.out.println("AuthUserController:findByName() method "+userName);
        return ResponseEntity.status(HttpStatus.OK).body(authUserService.findByUserName(userName));
    }
    @GetMapping("/user")
    public ResponseEntity<List<AuthUserDTO>> findAll(){
        System.out.println("AuthUserController:findByName() method ");
        return ResponseEntity.status(HttpStatus.OK).body(authUserService.findAll());
    }
    @PostMapping("/user")
    public ResponseEntity<String> createAuthUser(@Validated @RequestBody AuthUserDTO authUserDTO){
        System.out.println("AuthUserController:createAuthUser() method ");
        //return ResponseEntity.status(HttpStatus.CREATED).body(authUserService.createAuthUser(authUserDTO));
        return new ResponseEntity<>(authUserService.createAuthUser(authUserDTO), HttpStatus.CREATED);
    }
    @DeleteMapping("/user/{id}")
    public ResponseEntity<Void> deleteAuthUser(@PathVariable("id") int userId){
        System.out.println("AuthUserController:createAuthUser() method ");
        authUserService.deleteById(userId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
-------------------------EmployeeController.java----------------------------------------------------------------------
package com.cts.spring.controller;

import com.cts.spring.dto.EmployeeDTO;
import com.cts.spring.service.EmployeeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    @GetMapping("/employee/{id}")
    public ResponseEntity<EmployeeDTO> findById(@PathVariable("id") int empId){
        System.out.println("EmployeeController:getEmployee() method");
        return ResponseEntity.status(HttpStatus.OK).body(employeeService.findById(empId));
    }

    @GetMapping("/employee")
    @PreAuthorize("hasRole('ROLE_USER')")
    public ResponseEntity<List<EmployeeDTO>> findAll(){
        System.out.println("EmployeeController:findAll() method");
        //return ResponseEntity.status(HttpStatus.OK).body(employeeService.findAll());
        return new ResponseEntity<>(employeeService.findAll(), HttpStatus.OK);
    }

    @PostMapping("/employee")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<EmployeeDTO> createEmployee(@Validated @RequestBody EmployeeDTO employeeDTO){
        System.out.println("EmployeeController:createEmployee() method");
        return ResponseEntity.status(HttpStatus.CREATED).body(employeeService.save(employeeDTO));
    }

    @PutMapping("/employee")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<EmployeeDTO> updateEmployee(@RequestParam("id") int empId, @Valid @RequestBody EmployeeDTO employeeDTO){
        System.out.println("EmployeeController:updateEmployee() method "+empId);
        return ResponseEntity.status(HttpStatus.CREATED).body(employeeService.update(empId, employeeDTO));
    }

    @PatchMapping("/employee")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<EmployeeDTO> updateEmployee(@RequestParam("id") int empId, @RequestBody Map<String,String> mapUpdate){
        System.out.println("EmployeeController:updateEmployee() method "+empId);
        return ResponseEntity.status(HttpStatus.CREATED).body(employeeService.partialUpdate(empId, mapUpdate));
    }

    @DeleteMapping("/employee/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER')")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteEmployee(@PathVariable("id") int empId){
        System.out.println("EmployeeController:deleteEmployee() method");
        employeeService.deleteById(empId);
    }
}
