package myServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created with IntelliJ IDEA.
 * User: Vasya
 * Date: 05.04.13
 * Time: 15:12
 * To change this template use File | Settings | File Templates.
 */
public class IndexServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String login = request.getParameter("login");
        String passw = request.getParameter("passw");
        ResultSet resultSet = DataBaseConnection.getRecords("SELECT * FROM AUTHENTIFICATION WHERE LOGIN = '"
                                                            + login + "'");
        try {

            if (!resultSet.next() || !passw.equals(resultSet.getString("PASSW"))) {
                request.getRequestDispatcher("/loginFail.html").forward(request, response);
            } else {
                int role = Integer.parseInt(resultSet.getString("PERSON_ROLE"));
                int id = Integer.parseInt(resultSet.getString("ID"));
                switch (role){
                    case 0:
                        response.sendRedirect("/adminMain.jsp?role=" + role + "&id=" + id + "&mode=0");
                        break;
                    case 1:
                        response.sendRedirect("/editorMain.jsp?role=" + role + "&id=" + id);
                        break;
                    case 2:
                        response.sendRedirect("/authorMain.jsp?role=" + role + "&id=" + id);
                        break;
                    case 3:
                        response.sendRedirect("/reviewerMain.jsp?role=" + role + "&id=" + id);
                        break;
                    default:
                        response.sendRedirect("/loginFail.html");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
     public String getServletInfo() {
        return "Journal DB servlet";
    }
}
