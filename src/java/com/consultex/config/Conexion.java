package com.consultex.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/*
 * Clase encargada de gestionar la conexión con la base de datos MySQL.
 */
public class Conexion {
    
    private static final String URL = "jdbc:mysql://localhost:3306/consultex?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root"; 
    private static final String PASSWORD = ""; 
    
    private Connection con;

    // Método para establecer la conexión
    public Connection getConnection() {
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Intentar conectar a la base de datos
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conexión exitosa a la base de datos 'consultex'");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver de MySQL no encontrado. " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error al conectar con la base de datos. " + e.getMessage());
        }
        return con;
    }
    
    // Método para cerrar la conexión de forma segura
    public void cerrarConexion() {
        if (con != null) {
            try {
                con.close();
                System.out.println("Conexión cerrada correctamente.");
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión. " + e.getMessage());
            }
        }
    }
}