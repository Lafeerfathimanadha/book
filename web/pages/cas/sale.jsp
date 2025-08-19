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
              <div class="card">
                <div class="card-body">
                  <h4 class="card-title">New Sale</h4>

                  <form id="saleForm" method="post" action="<%=request.getContextPath()%>/CasSaleServlet">

                    <!-- Select Customer -->
                    <div class="form-group">
                      <label>Customer</label>
                      <select name="customer_id" class="form-control" id="customerSelect" required>
                        <option value="">--Select Customer--</option>
                        <%
                          try (Connection conn = DBConnection.getConnection()) {
                              Statement st = conn.createStatement();
                              ResultSet rs = st.executeQuery("SELECT id, name FROM customers");
                              while(rs.next()){
                        %>
                                  <option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
                        <%
                              }
                          } catch (Exception e) { e.printStackTrace(); }
                        %>
                      </select>
                      <button type="button" class="btn btn-sm btn-primary mt-2" onclick="window.location='customer.jsp'">Add New Customer</button>
                    </div>

                    <!-- Book Selection Table -->
                    <div class="table-responsive">
                      <table class="table table-bordered" id="booksTable">
                        <thead>
                          <tr>
                            <th>Book</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Discount</th>
                            <th>Total</th>
                            <th>Action</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td>
                              <select name="book_id[]" class="form-control bookSelect" onchange="updatePrice(this)" required>
                                <option value="">--Select Book--</option>
                                <%
                                  try (Connection conn = DBConnection.getConnection()) {
                                      Statement st = conn.createStatement();
                                      ResultSet rs = st.executeQuery("SELECT id, title, price, stock FROM books");
                                      while(rs.next()){
                                          int stock = rs.getInt("stock");
                                          double price = rs.getDouble("price");
                                %>
                                        <option value="<%=rs.getInt("id")%>" 
                                                data-price="<%=price%>" 
                                                data-stock="<%=stock%>" 
                                                <%= (stock == 0) ? "disabled style='color:gray;'" : "" %>>
                                          <%=rs.getString("title")%> 
                                          <%= (stock == 0) ? "(Out of Stock)" : "" %>
                                        </option>
                                <%
                                      }
                                  } catch (Exception e) { e.printStackTrace(); }
                                %>
                              </select>
                            </td>

                            <td><input type="number" class="form-control price" readonly></td>
                            <td><input type="number" name="quantity[]" class="form-control quantity" value="1" min="1" onchange="updateTotal(this)" required></td>
                            <td><input type="number" name="discount[]" class="form-control discount" value="0" onchange="updateTotal(this)"></td>
                            <td><input type="number" class="form-control total" readonly></td>
                            <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">Remove</button></td>
                          </tr>
                        </tbody>
                      </table>
                      <button type="button" class="btn btn-sm btn-success" onclick="addRow()">Add Book</button>
                    </div>

                    <!-- Summary -->
                    <div class="form-group mt-3">
                      <label>Total Amount:</label>
                      <input type="number" name="total_amount" id="totalAmount" class="form-control" readonly required>
                    </div>

                    <div class="form-group">
                      <label>Received Amount:</label>
                      <input type="number" name="received_amount" id="receivedAmount" class="form-control" onchange="updateBalance()" required>
                    </div>

                    <div class="form-group">
                      <label>Balance:</label>
                      <input type="number" id="balance" class="form-control" readonly>
                    </div>

                    <button type="submit" class="btn btn-primary">Complete Sale & Print Bill</button>
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
    <script>
        function updatePrice(select) {
            let row = select.closest("tr");
            let price = select.selectedOptions[0].dataset.price || 0;
            row.querySelector(".price").value = price;
            updateTotal(select);
        }

        function updateTotal(element) {
            let row = element.closest("tr");
            let price = parseFloat(row.querySelector(".price").value) || 0;
            let qty = parseInt(row.querySelector(".quantity").value) || 0;
            let discount = parseFloat(row.querySelector(".discount").value) || 0;
            let total = (price * qty) - discount;
            row.querySelector(".total").value = total.toFixed(2);
            updateTotalAmount();
        }

        function updateTotalAmount() {
            let totals = document.querySelectorAll(".total");
            let sum = 0;
            totals.forEach(t => sum += parseFloat(t.value) || 0);
            document.getElementById("totalAmount").value = sum.toFixed(2);
            updateBalance();
        }

        function updateBalance() {
            let total = parseFloat(document.getElementById("totalAmount").value) || 0;
            let received = parseFloat(document.getElementById("receivedAmount").value) || 0;
            document.getElementById("balance").value = (received - total).toFixed(2);
        }

        function addRow() {
            let table = document.getElementById("booksTable").getElementsByTagName('tbody')[0];
            let newRow = table.rows[0].cloneNode(true);
            newRow.querySelectorAll("input").forEach(input => input.value = input.classList.contains("quantity") ? 1 : 0);
            newRow.querySelector("select").selectedIndex = 0;
            table.appendChild(newRow);
        }

        function removeRow(btn) {
            let table = document.getElementById("booksTable").getElementsByTagName('tbody')[0];
            if(table.rows.length > 1){
                btn.closest("tr").remove();
                updateTotalAmount();
            }
        }


        function updatePrice(selectElement) {
            let selectedOption = selectElement.options[selectElement.selectedIndex];
            let stock = parseInt(selectedOption.getAttribute("data-stock"));

            if(stock === 0) {
                alert("This book is out of stock and cannot be added to the bill.");
                selectElement.value = ""; // reset selection
                return;
            }

            let price = parseFloat(selectedOption.getAttribute("data-price")) || 0;
            let row = selectElement.closest("tr");
            row.querySelector(".price").value = price;
            updateTotal(selectElement);
        }
    </script>

  </body>
</html>
