package myServlet;

import java.sql.*;
import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: Vasya
 * Date: 05.04.13
 * Time: 14:15
 * To change this template use File | Settings | File Templates.
 */
public class DataBaseConnection {
    private final static String DB_URL = "jdbc:firebirdsql://localhost:3050/C:/JOURNAL1251.FDB?ctype_none=WIN1251";//";
    private final static String DB_DEFAULT_USER = "SYSDBA";
    private final static String DB_DEFAULT_PASSWORD = "masterkey";

    public static ResultSet getRecords(String condition) {
        try {
            Class.forName("org.firebirdsql.jdbc.FBDriver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_DEFAULT_USER, DB_DEFAULT_PASSWORD);
            PreparedStatement statement = connection.prepareStatement(condition);
            ResultSet resultSet = statement.executeQuery();
            return resultSet;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return null;
        } catch (SQLException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return null;
        }
    }

    public static int sendUpdate(String query) {
        try {
            Class.forName("org.firebirdsql.jdbc.FBDriver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_DEFAULT_USER, DB_DEFAULT_PASSWORD);
            PreparedStatement statement = connection.prepareStatement(query);
            statement.executeUpdate();
            //connection.commit();   //not allowed in auto-commit mode
            statement.close();
            connection.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (SQLException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        return 1;
    }

    public static void updateTableRow(String table, ArrayList<String> columns, ArrayList<String> values, String conditions) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("UPDATE ");
        stringBuilder.append(table);
        stringBuilder.append(" SET ");
        stringBuilder.append(columns.get(0));
        stringBuilder.append(" = '");
        stringBuilder.append(values.get(0));
        for (int i=1; i<columns.size(); i++){
            stringBuilder.append("', ");
            stringBuilder.append(columns.get(i));
            stringBuilder.append(" = '");
            stringBuilder.append(values.get(i));
        }
        stringBuilder.append("' WHERE ");
        stringBuilder.append(conditions);
        System.out.println(stringBuilder);

        try {
            Class.forName("org.firebirdsql.jdbc.FBDriver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_DEFAULT_USER, DB_DEFAULT_PASSWORD);
            PreparedStatement statement = connection.prepareStatement(stringBuilder.toString());
            statement.executeUpdate();
            //connection.commit();   //not allowed in auto-commit mode
            statement.close();
            connection.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        } catch (SQLException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    public static void main (String[] args){

    }
}
