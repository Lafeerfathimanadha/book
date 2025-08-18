
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

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
      href="../../assets/vendors/mdi/css/materialdesignicons.min.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/ti-icons/css/themify-icons.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/css/vendor.bundle.base.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/font-awesome/css/font-awesome.min.css"
    />
    <!-- endinject -->
    <!-- Plugin css for this page -->
    <link
      rel="stylesheet"
      href="../../assets/vendors/jvectormap/jquery-jvectormap.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/flag-icon-css/css/flag-icons.min.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/owl-carousel-2/owl.carousel.min.css"
    />
    <link
      rel="stylesheet"
      href="../../assets/vendors/owl-carousel-2/owl.theme.default.min.css"
    />
    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <!-- endinject -->
    <!-- Layout styles -->
    <link rel="stylesheet" href="../../assets/css/style.css" />
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
                  <h5 class="mb-0 font-weight-normal">Cashier</h5>
                </div>
              </div>
            </div>
          </li>
          <li class="nav-item nav-category">
            <span class="nav-link">Navigation</span>
          </li>
          <li class="nav-item menu-items">
            <a class="nav-link" href="CasDashbord.jsp">
              <span class="menu-icon">
                <i class="mdi mdi-speedometer"></i>
              </span>
              <span class="menu-title">Dashboard</span>
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
          </div>
        </nav>
        <!-- partial -->
        <div class="main-panel">
          <div class="content-wrapper">
            <div class="row">
                <%
                    int totalBooks = 0;
                    int totalCustomers = 0;
                    double totalSales = 0;
                    double todayProfit = 0;

                    try (Connection conn = DBConnection.getConnection()) {

                        // Total books
                        PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM books");
                        ResultSet rs1 = ps1.executeQuery();
                        if (rs1.next()) totalBooks = rs1.getInt(1);
                        rs1.close(); ps1.close();

                        // Total customers
                        PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM customers");
                        ResultSet rs2 = ps2.executeQuery();
                        if (rs2.next()) totalCustomers = rs2.getInt(1);
                        rs2.close(); ps2.close();

                        // Total sales
                        PreparedStatement ps3 = conn.prepareStatement("SELECT SUM(total_amount) FROM sales");
                        ResultSet rs3 = ps3.executeQuery();
                        if (rs3.next()) totalSales = rs3.getDouble(1);
                        rs3.close(); ps3.close();

                        // Today's profit = (selling price - cost price) * quantity
                        // Assuming cost price = 70% of book price
                        PreparedStatement ps4 = conn.prepareStatement(
                            "SELECT SUM((si.price - (b.price * 0.7) - si.discount) * si.quantity) as profit " +
                            "FROM sale_items si " +
                            "JOIN sales s ON si.sale_id = s.id " +
                            "JOIN books b ON si.book_id = b.id " +
                            "WHERE DATE(s.sale_date) = CURDATE()"
                        );
                        ResultSet rs4 = ps4.executeQuery();
                        if (rs4.next()) todayProfit = rs4.getDouble("profit");
                        rs4.close(); ps4.close();

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>

                <!-- Total Books Card -->
                <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
                  <div class="card">
                    <div class="card-body">
                      <div class="row">
                        <div class="col-9">
                          <h3 class="mb-0"><%= totalBooks %></h3>
                        </div>
                        <div class="col-3">
                          <div class="icon icon-box-success">
                            <span class="mdi mdi-book icon-item"></span>
                          </div>
                        </div>
                      </div>
                      <h6 class="text-muted font-weight-normal">Total Books</h6>
                    </div>
                  </div>
                </div>

                <!-- Total Customers Card -->
                <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
                  <div class="card">
                    <div class="card-body">
                      <div class="row">
                        <div class="col-9">
                          <h3 class="mb-0"><%= totalCustomers %></h3>
                        </div>
                        <div class="col-3">
                          <div class="icon icon-box-info">
                            <span class="mdi mdi-account-multiple icon-item"></span>
                          </div>
                        </div>
                      </div>
                      <h6 class="text-muted font-weight-normal">Total Customers</h6>
                    </div>
                  </div>
                </div>

                <!-- Existing Cards (Revenue, Expense, etc.) -->
                <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
                  <div class="card">
                    <div class="card-body">
                      <div class="row">
                        <div class="col-9">
                          <h3 class="mb-0">Rs.<%= totalSales %></h3>
                        </div>
                        <div class="col-3">
                          <div class="icon icon-box-success">
                            <span class="mdi mdi-arrow-top-right icon-item"></span>
                          </div>
                        </div>
                      </div>
                      <h6 class="text-muted font-weight-normal">Total Sale</h6>
                    </div>
                  </div>
                </div>

                <div class="col-xl-3 col-sm-6 grid-margin stretch-card">
                  <div class="card">
                    <div class="card-body">
                      <div class="row">
                        <div class="col-9">
                          <h3 class="mb-0">Rs.<%= todayProfit %></h3>
                        </div>
                        <div class="col-3">
                          <div class="icon icon-box-success">
                            <span class="mdi mdi-arrow-top-right icon-item"></span>
                          </div>
                        </div>
                      </div>
                      <h6 class="text-muted font-weight-normal">Today's Profit</h6>
                    </div>
                  </div>
                </div>
              </div> 
                        
             <%
                List<String> labels = new ArrayList<>();
                List<Double> profitData = new ArrayList<>();

                try (Connection conn = DBConnection.getConnection()) {
                    for (int i = 6; i >= 0; i--) { // Last 7 days
                        PreparedStatement ps = conn.prepareStatement(
                            "SELECT SUM((si.price - (b.price * 0.7) - si.discount) * si.quantity) as profit " +
                            "FROM sale_items si " +
                            "JOIN sales s ON si.sale_id = s.id " +
                            "JOIN books b ON si.book_id = b.id " +
                            "WHERE DATE(s.sale_date) = CURDATE() - INTERVAL ? DAY"
                        );
                        ps.setInt(1, i);
                        ResultSet rs = ps.executeQuery();
                        double profit = 0;
                        if (rs.next()) profit = rs.getDouble("profit");
                        profitData.add(profit);
                        labels.add("Day-" + (7-i)); // Simple label, can use actual date if needed
                        rs.close(); ps.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>           

            <div class="row">
                <div class="col-12 grid-margin">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Profit Last 7 Days</h4>
                            <canvas id="profitLineChart" height="100"></canvas>
                        </div>
                    </div>
                </div>
            </div>


          </div>
        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="../../assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- endinject -->
    <!-- Plugin js for this page -->
    <script src="../../assets/vendors/chart.js/chart.umd.js"></script>
    <script src="../../assets/vendors/progressbar.js/progressbar.min.js"></script>
    <script src="../../assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../../assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <script src="../../assets/vendors/owl-carousel-2/owl.carousel.min.js"></script>
    <script src="../../assets/js/jquery.cookie.js" type="text/javascript"></script>
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="../../assets/js/off-canvas.js"></script>
    <script src="../../assets/js/misc.js"></script>
    <script src="../../assets/js/settings.js"></script>
    <script src="../../assets/js/todolist.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
    <script src="../../assets/js/proBanner.js"></script>
    <script src="../../assets/js/dashboard.js"></script>
    <!-- End custom js for this page -->
    <script>
        const ctx = document.getElementById('profitLineChart').getContext('2d');

        const profitChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<%= String.join(",", labels.stream().map(d -> "'" + d + "'").toArray(String[]::new)) %>],
                datasets: [{
                    label: 'Profit (Rs.)',
                    data: [<%= profitData.stream().map(d -> d.toString()).reduce((a,b)->a+","+b).orElse("") %>],
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: true },
                    tooltip: { mode: 'index', intersect: false }
                },
                interaction: { mode: 'nearest', axis: 'x', intersect: false },
                scales: {
                    x: { display: true, title: { display: true, text: 'Day' } },
                    y: { display: true, title: { display: true, text: 'Profit (Rs.)' } }
                }
            }
        });
    </script>
  </body>
</html>
