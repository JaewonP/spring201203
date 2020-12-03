<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 			</div>
                <!-- end of Page Content -->
            </div>
             <!-- end of Main Content -->
          </div>
           <!-- Footer -->
	      <footer class="sticky-footer bg-white">
	        <div class="container my-auto">
	          <div class="copyright text-center my-auto">
	            <span>저작권 &copy; 그린 컴퓨터  2020</span>
	          </div>
	        </div>
	      </footer>
      		<!-- End of Footer -->
      </div>
     <!-- end of Content Wrapper -->
</div>
  <!-- End of Page Wrapper -->
  <!-- Logout Modal-->
  <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
        <div class="modal-footer">
          <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
          <a class="btn btn-primary" href="login.html">Logout</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap core JavaScript-->
  <script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="/resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="/resources/js/sb-admin-2.min.js"></script>

  <!-- Page level plugins -->
  <script src="/resources/vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="/resources/vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="/resources/js/demo/datatables-demo.js"></script>
  <script>
  	$(document).ready(function(){
  		$('#dataTables-example').DataTable({
  			responsive:true
  		});
  		$(".sidebar-nav")
  			.attr("class" ,"sidebar-nav navbar-collapse collapse")
  			.attr("aria-expanded",'false')
  			.attr("style" ,"height:1px");  		
  	});
  	
  </script>

</body>

</html>
