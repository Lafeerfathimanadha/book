<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    int saleId = Integer.parseInt(request.getParameter("saleId"));
    Connection conn = null;
    PreparedStatement psSale = null;
    PreparedStatement psItems = null;
    ResultSet rsSale = null;
    ResultSet rsItems = null;

    try {
        conn = DBConnection.getConnection();

        // 1. Get sale info
        psSale = conn.prepareStatement("SELECT s.*, c.name, c.telephone FROM sales s JOIN customers c ON s.customer_id=c.id WHERE s.id=?");
        psSale.setInt(1, saleId);
        rsSale = psSale.executeQuery();

        if(rsSale.next()) {
%>
            <h2>Bill for Sale ID: <%= saleId %></h2>
            <p>Customer: <%= rsSale.getString("name") %></p>
            <p>Telephone: <%= rsSale.getString("telephone") %></p>
            <p>Sale Date: <%= rsSale.getTimestamp("sale_date") %></p>

            <h3>Items:</h3>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>Book</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Discount</th>
                    <th>Total</th>
                </tr>
<%
            // 2. Get sale items
            psItems = conn.prepareStatement(
                "SELECT si.*, b.title FROM sale_items si JOIN books b ON si.book_id=b.id WHERE si.sale_id=?"
            );
            psItems.setInt(1, saleId);
            rsItems = psItems.executeQuery();

            while(rsItems.next()) {
%>
                <tr>
                    <td><%= rsItems.getString("title") %></td>
                    <td><%= rsItems.getInt("quantity") %></td>
                    <td><%= rsItems.getDouble("price") %></td>
                    <td><%= rsItems.getDouble("discount") %></td>
                    <td><%= rsItems.getDouble("total") %></td>
                </tr>
<%
            } // end while
%>
            </table>

            <h3>Summary:</h3>
            <p>Total Amount: <%= rsSale.getDouble("total_amount") %></p>
            <p>Received Amount: <%= rsSale.getDouble("received_amount") %></p>
            <p>Balance: <%= rsSale.getDouble("received_amount") - rsSale.getDouble("total_amount") %></p>
<%
        } else {
%>
            <p>Sale not found!</p>
<%
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(rsItems != null) try { rsItems.close(); } catch(Exception e) {}
        if(psItems != null) try { psItems.close(); } catch(Exception e) {}
        if(rsSale != null) try { rsSale.close(); } catch(Exception e) {}
        if(psSale != null) try { psSale.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
