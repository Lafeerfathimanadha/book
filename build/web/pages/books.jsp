
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

                <div class="d-flex justify-content-between mb-3">
                    <h4>Books Table</h4>
                    <!-- Add Book Button -->
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBookModal">Add Book</button>
                </div>
                
                

                <div class="table-responsive">
                    
                    <%
                        List<String> lowStockBooks = new ArrayList<>();
                        try(Connection conn = DBConnection.getConnection()){
                            String sql = "SELECT * FROM books";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();
                    %>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Book Code</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while(rs.next()){
                                    int stock = rs.getInt("stock");
                                    String rowClass = stock <= 3 ? "table-danger" : "";
                                    if(stock <= 3) lowStockBooks.add(rs.getString("title"));
                            %>
                            <tr class="<%= rowClass %>">
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("title") %></td>
                                <td><%= rs.getString("author") %></td>
                                <td><%= rs.getString("book_code") %></td>
                                <td><%= rs.getDouble("price") %></td>
                                <td><%= stock %></td>
                                <td>
                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editBookModal<%=rs.getInt("id")%>">Edit</button>
                                    <a href="<%=request.getContextPath()%>/DeleteBookServlet?id=<%=rs.getInt("id")%>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                </td>
                            </tr>

                            <!-- Edit Book Modal -->
                            <div class="modal fade" id="editBookModal<%=rs.getInt("id")%>" tabindex="-1" aria-labelledby="editBookModalLabel<%=rs.getInt("id")%>" aria-hidden="true">
                              <div class="modal-dialog">
                                <form action="<%=request.getContextPath()%>/EditBookServlet" method="post">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="editBookModalLabel<%=rs.getInt("id")%>">Edit Book</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
                                            <div class="mb-3">
                                                <label>Title</label>
                                                <input type="text" name="title" class="form-control" value="<%=rs.getString("title")%>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label>Author</label>
                                                <input type="text" name="author" class="form-control" value="<%=rs.getString("author")%>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label>Book Code</label>
                                                <input type="text" name="book_code" class="form-control" value="<%=rs.getString("book_code")%>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label>Price</label>
                                                <input type="number" name="price" class="form-control" step="0.01" value="<%=rs.getDouble("price")%>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label>Stock</label>
                                                <input type="number" name="stock" class="form-control" value="<%=stock%>" required>
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
                                rs.close();
                                ps.close();
                            %>
                        </tbody>
                    </table>
                    <%
                        } catch(Exception e){
                            e.printStackTrace();
                        }
                    %>
                </div>

                
            </div>
        </div>
                        
                        

        <!-- Add Book Modal -->
        <div class="modal fade" id="addBookModal" tabindex="-1" aria-labelledby="addBookModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <form action="<%=request.getContextPath()%>/AddBookServlet" method="post">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addBookModalLabel">Add New Book</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Title</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Author</label>
                            <input type="text" name="author" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Book Code</label>
                            <input type="text" name="book_code" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Price</label>
                            <input type="number" name="price" class="form-control" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label>Stock</label>
                            <input type="number" name="stock" class="form-control" required>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Add Book</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
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
