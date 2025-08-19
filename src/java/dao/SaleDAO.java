/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Sale;
import model.SaleItem;
import utils.DBConnection;

public class SaleDAO {

    public List<Sale> getAllSales() {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT s.id, s.customer_id, c.name, s.total_amount, s.received_amount, s.sale_date " +
                     "FROM sales s JOIN customers c ON s.customer_id = c.id ORDER BY s.sale_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Sale sale = new Sale();
                sale.setId(rs.getInt("id"));
                sale.setCustomerId(rs.getInt("customer_id"));
                sale.setCustomerName(rs.getString("name"));
                sale.setTotalAmount(rs.getDouble("total_amount"));
                sale.setReceivedAmount(rs.getDouble("received_amount"));
                sale.setSaleDate(rs.getDate("sale_date"));
                sales.add(sale);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
    }

    public List<SaleItem> getSaleItemsBySaleId(int saleId) {
        List<SaleItem> items = new ArrayList<>();
        String sql = "SELECT si.id, si.book_id, b.title, si.quantity, si.price, si.discount, si.total " +
                     "FROM sale_items si JOIN books b ON si.book_id = b.id " +
                     "WHERE si.sale_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, saleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = new SaleItem();
                    item.setId(rs.getInt("id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setBookTitle(rs.getString("title"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setDiscount(rs.getDouble("discount"));
                    item.setTotal(rs.getDouble("total"));
                    items.add(item);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    public List<Sale> searchSales(String customerName, String saleDate) {
    List<Sale> sales = new ArrayList<>();
    String sql = "SELECT s.id, s.customer_id, c.name, s.total_amount, s.received_amount, s.sale_date " +
                 "FROM sales s JOIN customers c ON s.customer_id = c.id WHERE 1=1";

    if (customerName != null && !customerName.isEmpty()) {
        sql += " AND c.name LIKE ?";
    }
    if (saleDate != null && !saleDate.isEmpty()) {
        sql += " AND s.sale_date = ?";
    }
    sql += " ORDER BY s.sale_date DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        int index = 1;
        if (customerName != null && !customerName.isEmpty()) {
            ps.setString(index++, "%" + customerName + "%");
        }
        if (saleDate != null && !saleDate.isEmpty()) {
            ps.setDate(index++, java.sql.Date.valueOf(saleDate));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Sale sale = new Sale();
            sale.setId(rs.getInt("id"));
            sale.setCustomerName(rs.getString("name"));
            sale.setTotalAmount(rs.getDouble("total_amount"));
            sale.setReceivedAmount(rs.getDouble("received_amount"));
            sale.setSaleDate(rs.getDate("sale_date"));
            sales.add(sale);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return sales;
}

}



