<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    String type = request.getParameter("type");
    if(type == null) type = "today";

    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"sales_report.csv\"");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        String whereClause = "";
        switch(type) {
            case "today":
                whereClause = "DATE(sale_date) = CURDATE()";
                break;
            case "yesterday":
                whereClause = "DATE(sale_date) = CURDATE() - INTERVAL 1 DAY";
                break;
            case "weekly":
                whereClause = "YEARWEEK(sale_date, 1) = YEARWEEK(CURDATE(), 1)";
                break;
            case "monthly":
                whereClause = "MONTH(sale_date) = MONTH(CURDATE()) AND YEAR(sale_date) = YEAR(CURDATE())";
                break;
            case "yearly":
                whereClause = "YEAR(sale_date) = YEAR(CURDATE())";
                break;
        }

        ps = conn.prepareStatement(
            "SELECT s.id, c.name, s.total_amount, s.received_amount, s.sale_date " +
            "FROM sales s JOIN customers c ON s.customer_id=c.id WHERE " + whereClause
        );
        rs = ps.executeQuery();

        out.println("Sale ID,Customer,Total Amount,Received Amount,Sale Date");
        while(rs.next()) {
            out.println(rs.getInt("id") + "," + 
                        rs.getString("name") + "," +
                        rs.getDouble("total_amount") + "," +
                        rs.getDouble("received_amount") + "," +
                        rs.getTimestamp("sale_date"));
        }

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
