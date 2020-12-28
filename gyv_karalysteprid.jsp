<!DOCTYPE html>
<%@page pageEncoding="UTF-8" language="java"%>
<%@page contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<meta charset="utf-8">
		<style>
			table {
				border-collapse: collapse;
			}
			form {
				float: right;
			}
			input {
				width: 111px;
			}
			th, td {
				padding: 3px 4px;
				border: 1px solid black;
			}
			th {
				background-color: #A52A2A;
			}
			td {
				background-color: #DEB887;			
			}
		</style>
	</head>
<body>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<%

	String driverName = "com.mysql.jdbc.Driver";
	String connectionUrl = "jdbc:mysql://localhost:3306/";
	String dbName = "gyv_karalyste";
	String userId = "root";
	String password = "";

	Connection connection = null;
	Statement statement_take = null;
	Statement statement_change = null;
	ResultSet resultSet = null;
	int resultSetChange;

%>
<h2 align="center"><strong>Retrieve data from database in jsp</strong></h2>
<form method="post" action="">
	<table>
		<tr>
			<th>Pavadinimas</th>
			<td>
				<input type="text" name="pav" required>
			</td>
			<td rowspan="6">
		</tr>
		<tr>
			<th>Kar. Pavadinimas</th>
			<td>
				<input type="text" name="kar_pav">
			</td>
		</tr>
		<tr>
			<th> Valgomas</th>
			<td>
				<input type="number" name="valgomas" value="0">
			</td>
		</tr>
		<tr>
			<td colspan="2">
			</td>
			<td>
				<input type="button" name="clear" value="valyti"> 
				<input type="submit" name="add" value="papildyti">
			</td>
		</tr>
	</table>
		<input type="hidden" name="id_gyvuno" value="0">
</form>
<table align="center">
<tr>
</tr>
<tr>
	<th>id</th>
	<th>Pavadinimas</th>
	<th>Kar. Pavadinimas</th>
	<th>Valgomas</th>
</tr>
<%
	String[] lent_gyvunu = { "pav", "kar_pav", "valgomas" };
	String[] lauk_gyvuno = new String [ lent_gyvunu.length ];
	try{
	     
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");		
		
	} catch(Exception e) {}

	try { 
	
		connection = DriverManager.getConnection ( connectionUrl + dbName + "?useUnicode=yes&characterEncoding=UTF-8", userId, password );
		String add; 
		
		if ( ( ( add = request.getParameter("add")  ) != null ) && add.equals ( "papildyti" ) ) {
		
																																					// Miestai miestas = new Miestai ( lent_miestu );
																																					// miestas.takeFromParams ( request );

			for ( int i = 0; i < lent_gyvunu.length; i++ ) {
			
				lauk_gyvuno [ i ] = request.getParameter ( lent_gyvunu [ i ] );
			}

			String sql_ins = "";
			String comma = "";
			
			for ( int i = 0; i < lent_gyvunu.length; i++ ) {
			
				sql_ins =  sql_ins + comma  + "'" + lauk_gyvuno [ i ] + "'";
				comma = ",";																													// sql_ins = sql_ins + "'" + Miestai.value + "'";
			}
			
			sql_ins = 
				"INSERT INTO `sub_karalyste`"
				+ " ( `pav`, `kar_pav`, `valgomas` )"
				+ " VALUES ( "			
				+ sql_ins
				+ " )";

			out.println ( sql_ins );

			statement_change = connection.createStatement();
			resultSetChange = statement_change.executeUpdate(sql_ins);			
			
		 } else {
		 
			if ( add != null ) {

				out.println ( add );
			}
		 } 
		
		statement_take = connection.createStatement();		
		String sql ="SELECT * FROM `sub_karalyste`  WHERE 1";

		resultSet = statement_take.executeQuery(sql);
		 
		while( resultSet.next() ){
%>
<tr>
	<td><input type="button" class="record_edit" data-id_gyvuno="" value="&#9998;"></td>
<%
		for ( int i = 0; i < lauk_gyvuno.length; i++ ) {
%>
	<td><%= resultSet.getString (  lent_gyvunu [ i ]  ) %></td>
<%
		}
%>
</tr>
<% 
		}

	} catch ( Exception e ) {
	
		e.printStackTrace();
	}
%>
</table>
</body>