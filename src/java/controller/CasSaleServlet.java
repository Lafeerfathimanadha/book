/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import utils.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
/**
 *
 * @author HP
 */
@WebServlet("/CasSaleServlet")
public class CasSaleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // handle UTF characters

        try {
            int customerId = Integer.parseInt(request.getParameter("customer_id"));
            double totalAmount = Double.parseDouble(request.getParameter("total_amount"));
            double receivedAmount = Double.parseDouble(request.getParameter("received_amount"));

            String[] bookIds = request.getParameterValues("book_id[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] discounts = request.getParameterValues("discount[]");

            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // transaction start

            try {
                // Insert Sale
                PreparedStatement psSale = conn.prepareStatement(
                        "INSERT INTO sales(customer_id, total_amount, received_amount, sale_date) VALUES (?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS
                );
                psSale.setInt(1, customerId);
                psSale.setDouble(2, totalAmount);
                psSale.setDouble(3, receivedAmount);
                psSale.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                psSale.executeUpdate();

                ResultSet rs = psSale.getGeneratedKeys();
                int saleId = 0;
                if (rs.next()) {
                    saleId = rs.getInt(1);
                }

                // Insert Sale Items and Update Stock
                for (int i = 0; i < bookIds.length; i++) {
                    int bookId = Integer.parseInt(bookIds[i]);
                    int qty = Integer.parseInt(quantities[i]);
                    double discount = Double.parseDouble(discounts[i]);

                    // Fetch price & stock
                    PreparedStatement psBook = conn.prepareStatement("SELECT price, stock FROM books WHERE id=?");
                    psBook.setInt(1, bookId);
                    ResultSet rsBook = psBook.executeQuery();

                    if (rsBook.next()) {
                        double price = rsBook.getDouble("price");
                        int stock = rsBook.getInt("stock");

                        if (qty > stock) {
                            throw new Exception("Not enough stock for book ID: " + bookId);
                        }

                        double itemTotal = (price * qty) - discount;

                        // Insert sale item
                        PreparedStatement psItem = conn.prepareStatement(
                                "INSERT INTO sale_items(sale_id, book_id, quantity, price, discount, total) VALUES (?, ?, ?, ?, ?, ?)"
                        );
                        psItem.setInt(1, saleId);
                        psItem.setInt(2, bookId);
                        psItem.setInt(3, qty);
                        psItem.setDouble(4, price);
                        psItem.setDouble(5, discount);
                        psItem.setDouble(6, itemTotal);
                        psItem.executeUpdate();

                        // Update stock
                        PreparedStatement psUpdateStock = conn.prepareStatement(
                                "UPDATE books SET stock = stock - ? WHERE id=?"
                        );
                        psUpdateStock.setInt(1, qty);
                        psUpdateStock.setInt(2, bookId);
                        psUpdateStock.executeUpdate();
                    }
                }

                conn.commit(); // commit transaction

                // Redirect to bill printing page
                response.sendRedirect("pages/cas/printBill.jsp?saleId=" + saleId);

            } catch (Exception e) {
                conn.rollback(); // rollback on error
                e.printStackTrace();
                response.getWriter().println("Sale failed: " + e.getMessage());
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().println("Invalid input: " + ex.getMessage());
        }
    }
}
