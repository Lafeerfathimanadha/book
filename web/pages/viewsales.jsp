

<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.*, dao.SaleDAO, model.Sale, model.SaleItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    SaleDAO saleDAO = new SaleDAO();
    List<Sale> sales = saleDAO.getAllSales();
%>
<%
    String customerName = request.getParameter("customerName");
    String saleDate = request.getParameter("saleDate");
   
    
    if ((customerName != null && !customerName.isEmpty()) || (saleDate != null && !saleDate.isEmpty())) {
        sales = saleDAO.searchSales(customerName, saleDate);
    } else {
        sales = saleDAO.getAllSales();
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
            <div class="container mt-5">
                <h2>Sales List</h2>
                
                <!-- Search Form -->
                <form method="get" class="row g-3 mb-3">
                    <div class="col-md-4">
                        <input type="text" name="customerName" class="form-control" placeholder="Customer Name" value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>">
                    </div>
                    <div class="col-md-4">
                        <input type="date" name="saleDate" class="form-control" value="<%= request.getParameter("saleDate") != null ? request.getParameter("saleDate") : "" %>">
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="viewsales.jsp" class="btn btn-secondary">Reset</a>
                    </div>
                </form>
                
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Customer</th>
                            <th>Total Amount</th>
                            <th>Received Amount</th>
                            <th>Sale Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Sale sale : sales) {
                        %>
                        <tr>
                            <td><%= sale.getId() %></td>
                            <td><%= sale.getCustomerName() %></td>
                            <td><%= sale.getTotalAmount() %></td>
                            <td><%= sale.getReceivedAmount() %></td>
                            <td><%= sale.getSaleDate() %></td>
                            <td>
                                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#saleModal<%= sale.getId() %>">
                                    View
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="saleModal<%= sale.getId() %>" tabindex="-1">
                                  <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                      <div class="modal-header">
                                        <h5 class="modal-title">Sale Items for Sale ID <%= sale.getId() %></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                      </div>
                                      <div class="modal-body">
                                        <!-- Customer Name -->
                                        <h5>Customer: <%= sale.getCustomerName() %></h5>

                                        <!-- Sale Items Table -->
                                        <table class="table table-bordered mt-3">
                                          <thead>
                                            <tr>
                                              <th>Book Title</th>
                                              <th>Quantity</th>
                                              <th>Price</th>
                                              <th>Discount</th>
                                              <th>Total</th>
                                            </tr>
                                          </thead>
                                          <tbody>
                                            <%
                                                List<SaleItem> items = saleDAO.getSaleItemsBySaleId(sale.getId());
                                                for (SaleItem item : items) {
                                            %>
                                            <tr>
                                              <td><%= item.getBookTitle() %></td>
                                              <td><%= item.getQuantity() %></td>
                                              <td><%= item.getPrice() %></td>
                                              <td><%= item.getDiscount() %></td>
                                              <td><%= item.getTotal() %></td>
                                            </tr>
                                            <% } %>
                                          </tbody>
                                        </table>

                                        <!-- Summary -->
                                        <div class="mt-3">
                                            <p><strong>Total Amount:</strong> <%= sale.getTotalAmount() %></p>
                                            <p><strong>Received Amount:</strong> <%= sale.getReceivedAmount() %></p>
                                            <p><strong>Balance:</strong> <%= sale.getTotalAmount() - sale.getReceivedAmount() %></p>
                                        </div>
                                    </div>

                                      <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                      </div>
                                    </div>
                                  </div>
                                </div>

                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>


          </div>
        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="../assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
