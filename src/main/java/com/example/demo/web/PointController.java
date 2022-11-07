package com.example.demo.web;

import com.example.demo.business.PointService;
import com.example.demo.data.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
public class PointController {

    private final PointService services;

    @Autowired
    public PointController(PointService services) {
        this.services = services;
    }

    @GetMapping("/")
    public ResponseEntity<?> getListOfPoints(){
        return ResponseEntity.ok(services.getPoints());
    }

    @GetMapping("/{num}")
    public ResponseEntity<?> getListOfPointsTo(@PathVariable("num")  int num){
        return ResponseEntity.ok(services.getPoints(num));
    }

    @GetMapping("/distance/{x}/{y}")
    public ResponseEntity<?> getDistance(@PathVariable("x") int x, @PathVariable("y") int y){
        return ResponseEntity.ok(services.getDistance(new Point(x,x), new Point(y,y)));
    }

    @PostMapping("/add/{x}/{y}")
    public ResponseEntity<?> addPoint(@PathVariable("x") int x, @PathVariable("y") int y){
        return ResponseEntity.ok(services.addPoint(new Point(x,y)));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePoint(@PathVariable("id") int id){
        return ResponseEntity.ok(services.deletePoint(id));
    }
}



