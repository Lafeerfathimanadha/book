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

    <div class="d-flex justify-content-between mb-3">
        <h4>Customer Table</h4>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">Add Customer</button>
    </div>

    <div class="table-responsive">
      <table class="table table-hover">
        <thead>
          <tr>
            <th>Account Number</th>
            <th>Name</th>
            <th>Address</th>
            <th>Telephone</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
              try(Connection conn = DBConnection.getConnection()){
                  String sql = "SELECT * FROM customers";
                  PreparedStatement ps = conn.prepareStatement(sql);
                  ResultSet rs = ps.executeQuery();
                  while(rs.next()){
          %>
          <tr>
              <td><%= rs.getString("account_number") %></td>
              <td><%= rs.getString("name") %></td>
              <td><%= rs.getString("address") %></td>
              <td><%= rs.getString("telephone") %></td>
              <td>
                  <!-- Edit Button -->
                  <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editCustomerModal<%=rs.getString("account_number")%>">Edit</button>
              </td>
          </tr>

          <!-- Edit Customer Modal -->
          <div class="modal fade" id="editCustomerModal<%=rs.getString("account_number")%>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
              <form action="<%=request.getContextPath()%>/EditCasCustomerServlet" method="post">
                  <div class="modal-content">
                      <div class="modal-header">
                          <h5 class="modal-title">Edit Customer</h5>
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                      </div>
                      <div class="modal-body">
                          <input type="hidden" name="account_number" value="<%=rs.getString("account_number")%>">
                          <div class="mb-3">
                              <label>Name</label>
                              <input type="text" name="name" class="form-control" value="<%=rs.getString("name")%>" required>
                          </div>
                          <div class="mb-3">
                              <label>Address</label>
                              <input type="text" name="address" class="form-control" value="<%=rs.getString("address")%>" required>
                          </div>
                          <div class="mb-3">
                              <label>Telephone</label>
                              <input type="text" name="telephone" class="form-control" value="<%=rs.getString("telephone")%>" required>
                          </div>
                      </div>
                      <div class="modal-footer">
                          <button type="submit" class="btn btn-success">Save Changes</button>
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                      </div>
                  </div>
              </form>
            </div>
          </div>

          <%
                  }
              } catch(Exception e){
                  e.printStackTrace();
              }
          %>
        </tbody>
      </table>
    </div>
        
        
        <!-- Add Customer Modal -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form action="<%=request.getContextPath()%>/AddCasCustomerServlet" method="post">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCustomerModalLabel">Add New Customer</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Account Number</label>
                    <input type="text" name="account_number" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Telephone</label>
                    <input type="text" name="telephone" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Add Customer</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </form>
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
  </body>
</html>
