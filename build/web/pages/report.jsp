

<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.*" %>

<%
    String type = request.getParameter("type");
    if(type == null) type = "today"; // default report

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    double totalSales = 0;
    double totalProfit = 0;
    int totalCustomers = 0;
    int totalBooksSold = 0;
    double cashOnHand = 0;

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

        // Total sales
        ps = conn.prepareStatement("SELECT SUM(total_amount) as total FROM sales s WHERE " + whereClause);
        rs = ps.executeQuery();
        if(rs.next()) totalSales = rs.getDouble("total");
        rs.close();
        ps.close();

        // Total customers
        ps = conn.prepareStatement("SELECT COUNT(DISTINCT customer_id) as total FROM sales s WHERE " + whereClause);
        rs = ps.executeQuery();
        if(rs.next()) totalCustomers = rs.getInt("total");
        rs.close();
        ps.close();

        // Total books sold
        ps = conn.prepareStatement(
            "SELECT SUM(si.quantity) as totalBooks, SUM((si.price - si.discount) * si.quantity) as profit " +
            "FROM sale_items si JOIN sales s ON si.sale_id = s.id WHERE " + whereClause
        );
        rs = ps.executeQuery();
        if(rs.next()) {
            totalBooksSold = rs.getInt("totalBooks");
            totalProfit = rs.getDouble("profit");
        }
        rs.close();
        ps.close();

        // Cash on hand (received amount)
        ps = conn.prepareStatement("SELECT SUM(received_amount) as cash FROM sales s WHERE " + whereClause);
        rs = ps.executeQuery();
        if(rs.next()) cashOnHand = rs.getDouble("cash");
        rs.close();
        ps.close();

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>


<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <title>book</title>
    <!-- plugins:css -->
    <link
      rel="stylesheet"
      href="../assets/vendors/mdi/css/materialdesignicons.min.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/ti-icons/css/themify-icons.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/css/vendor.bundle.base.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/font-awesome/css/font-awesome.min.css"
    />
    <!-- endinject -->
    <!-- Plugin css for this page -->
    <link
      rel="stylesheet"
      href="../assets/vendors/jvectormap/jquery-jvectormap.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/flag-icon-css/css/flag-icons.min.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/owl-carousel-2/owl.carousel.min.css"
    />
    <link
      rel="stylesheet"
      href="../assets/vendors/owl-carousel-2/owl.theme.default.min.css"
    />
    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="../assets/css/style.css" />
    <!-- End layout styles -->
  </head>
  <body>
    <div class="container-scroller">
      <!-- partial:partials/_sidebar.html -->
      <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <div
          class="sidebar-brand-wrapper d-none d-lg-flex align-items-center justify-content-center fixed-top"
        >
          <a class="sidebar-brand brand-logo" href="index.html">
              <span style="font-weight: bold; font-size: 1.5rem; color: #fff;">Pahana Edu</span>
          </a>
          <a class="sidebar-brand brand-logo-mini" href="index.html">
              <span style="font-weight: bold; font-size: 1.2rem; color: #fff;">P E</span>
          </a>
        </div>
        <ul class="nav">
          <li class="nav-item profile">
            <div class="profile-desc">
              <div class="profile-pic">
                <div class="count-indicator"></div>
                <div class="profile-name">
                  <h5 class="mb-0 font-weight-normal">Admin</h5>
                </div>
              </div>
            </div>
          </li>
          <li class="nav-item nav-category">
            <span class="nav-link">Navigation</span>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="dashbord.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-speedometer"></i>
              </span>
              <span class="menu-title">Dashboard</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="books.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-book-open-page-variant-outline"></i>
              </span>
              <span class="menu-title">Books</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="customer.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-account-box"></i>
              </span>
              <span class="menu-title">Customer</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="sale.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-cart-check"></i>
              </span>
              <span class="menu-title">Sale</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="viewsales.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-chart-line"></i>
              </span>
              <span class="menu-title">View Sales</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="report.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-file-document-outline"></i>
              </span>
              <span class="menu-title">Report</span>
            </a>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="<%=request.getContextPath()%>/LogoutServlet">
              <span class="menu-icon">
                <i class="mdi mdi-logout"></i>
              </span>
              <span class="menu-title">Logout</span>
            </a>
          </li>
        </ul>
      </nav>
      <!-- partial -->
      <div class="container-fluid page-body-wrapper">
        <!-- partial:partials/_navbar.html -->
        <nav class="navbar p-0 fixed-top d-flex flex-row">
          <div class="navbar-menu-wrapper flex-grow d-flex align-items-stretch">
            <button
              class="navbar-toggler navbar-toggler align-self-center"
              type="button"
              data-toggle="minimize"
            >
              <span class="mdi mdi-menu"></span>
            </button>
            <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
              <span class="mdi mdi-format-line-spacing"></span>
            </button>
          </div>
        </nav>
        <!-- partial -->
        <div class="main-panel">
            <div class="content-wrapper">

               <h2>Sales Report</h2>
<div>
    <a href="report.jsp?type=today"><button>Today</button></a>
    <a href="report.jsp?type=yesterday"><button>Yesterday</button></a>
    <a href="report.jsp?type=weekly"><button>Weekly</button></a>
    <a href="report.jsp?type=monthly"><button>Monthly</button></a>
    <a href="report.jsp?type=yearly"><button>Yearly</button></a>
</div>

<h3>Report Type: <%= type.toUpperCase() %></h3>
<table border="1" cellpadding="5" cellspacing="0">
    <tr><th>Total Sales</th><td><%= totalSales %></td></tr>
    <tr><th>Total Profit</th><td><%= totalProfit %></td></tr>
    <tr><th>Total Customers</th><td><%= totalCustomers %></td></tr>
    <tr><th>Total Books Sold</th><td><%= totalBooksSold %></td></tr>
    <tr><th>Cash on Hand</th><td><%= cashOnHand %></td></tr>
</table>

<br>
<form action="downloadReport.jsp" method="get">
    <input type="hidden" name="type" value="<%= type %>" />
    <button type="submit">Download CSV</button>
</form>
            </div>
        </div>
    
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="../assets/vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->
    <!-- Plugin js for this page -->
    <script src="../assets/vendors/chart.js/chart.umd.js"></script>
    <script src="../assets/vendors/progressbar.js/progressbar.min.js"></script>
    <script src="../assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <script src="../assets/vendors/owl-carousel-2/owl.carousel.min.js"></script>
    <script src="../assets/js/jquery.cookie.js" type="text/javascript"></script>
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="../assets/js/off-canvas.js"></script>
    <script src="../assets/js/misc.js"></script>
    <script src="../assets/js/settings.js"></script>
    <script src="../assets/js/todolist.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
    <script src="../assets/js/proBanner.js"></script>
    <script src="../assets/js/dashboard.js"></script>
    <!-- End custom js for this page -->
  </body>
</html>
