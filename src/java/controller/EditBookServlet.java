/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import utils.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 *
 * @author HP
 */
@WebServlet("/EditBookServlet")
public class EditBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String book_code = request.getParameter("book_code");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        try(Connection conn = DBConnection.getConnection()){
            String sql = "UPDATE books SET title=?, author=?, book_code=?, price=?, stock=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, book_code);
            ps.setDouble(4, price);
            ps.setInt(5, stock);
            ps.setInt(6, id);
            ps.executeUpdate();

            response.sendRedirect("pages/books.jsp");
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("pages/books.jsp?error=1");
        }
    }
}
