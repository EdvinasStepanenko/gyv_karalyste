<!DOCTYPE html>
<%@page pageEncoding="UTF-8" language="java"%>
<%@page contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<meta charset="utf-8">
		<style>
			th {
				background-color: #A52A2A
			}
		</style>
	</head>
<body>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<%
// String id = request.getParameter("userId");
	String driverName = "com.mysql.jdbc.Driver";
	String connectionUrl = "jdbc:mysql://localhost:3306/";
	String dbName = "gyv_karalyste";
	String userId = "root";
	String password = "";
/*
try {
Class.forName(driverName);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
*/
	Connection connection = null;
	Statement statement = null;
	ResultSet resultSet = null;
/*
	2	id	int(10)
	3	pav	varchar(24) utf8_lithuanian_ci
	4	kar_pav	varchar(24) utf8_lithuanian_ci
	5	valgomas	tinyint(1)
	
*/
%>
<form method="post" action="">
<table>
<tr>
	<th>Karalyste</th>
	<td>
		<input type="text" name="pav" required>
	</td>
</tr>

<tr>

		<td>
			<input type="submit" name="add" value="papildyti">
		</td>	
</tr>
</table>
<h2 align="center"><strong>Retrieve data from database in jsp</strong></h2>
<table align="center" cellpadding="5" cellspacing="5" border="1">
<tr>

</tr>
<tr>
	<th>kodas</th>
	<th>Pavadinimas</th>
	<th>sk_karalysciu..</th>
	<th>sugrupuota</th>
</tr>

<%

	String[] lent_gyv = {  "kodas", "pavadinimas", "sk_karalysciu", "sugrupuota" };
	String[] lauk_gyv = new String [ lent_gyv.length ];
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

			for ( int i = 0; i<lent_gyv.length; i++ ) {
			
				lauk_gyv [ i ] = request.getParameter ( lent_gyv [ i ] );
			}

			String sql_ins = "";
			String comma = "";
			
			for ( int i = 0; i < lent_gyv.length; i++ ) {
			
				sql_ins =  sql_ins + comma  + "'" + lauk_gyv [ i ] + "'";
				comma = ",";																													// sql_ins = sql_ins + "'" + Miestai.value + "'";
			}
			
			sql_ins = 
				"SELECT `domenas`.*"	 
				+ ", COUNT( `karalystes`.`id` ) AS `sk_karalysciu` " 
				+ ", GROUP_CONCAT( CONCAT( `karalystes`.`pav`, '(', `sub_karalyste`.`pav`, ') ') ) AS `sugrupuota`"
				+ "FROM `domenas` "
				+ "LEFT JOIN `karalystes` ON ( `karalystes`.`domeno_kodas`=`domenas`.`kodas` ) "
				+ "LEFT JOIN `sub_karalyste` ON ( `karalystes`.`pav`=`sub_karalyste`.`kar_pav` ) "
				+ "WHERE `sub_karalyste`.`kar_pav`= "
				+ sql_ins 
				+ "GROUP BY `domenas`.`kodas`";

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
	<td><input type="button" class="record_edit" data-id_miesto="" value="&#9998;"></td>
<%
		for ( int i = 0; i < lauk_gyv.length; i++ ) {
%>
	<td><%= resultSet.getString (  lent_miestu [ i ]  ) %></td>
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