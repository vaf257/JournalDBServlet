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
 * Date: 19.04.13
 * Time: 12:10
 * To change this template use File | Settings | File Templates.
 */
public class NewArticleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int msg;
        req.setCharacterEncoding("WINDOWS-1251");
        int id = Integer.parseInt(req.getParameter("id"));
        int role = Integer.parseInt(req.getParameter("role"));
        int theme_id = Integer.parseInt(req.getParameter("themeValue"));
        String title = req.getParameter("title");
        String date = req.getParameter("date");

        if (title.equals("") || date.equals("")){
            msg = 1;
        } else {

            DataBaseConnection.sendUpdate("INSERT INTO ARTICLE VALUES "
                    + "(Null, " + theme_id + ", '" + title + "', Null, '" + date + "', Null);");
            ResultSet resultSet = DataBaseConnection.getRecords("SELECT MAX(ARTICLE_ID) FROM ARTICLE ");
            try {
                if (resultSet.next()){
                    int art_id = Integer.parseInt(resultSet.getString(1));
                    DataBaseConnection.sendUpdate("INSERT INTO ARTICLE_AUTHORS (ARTICLE_ID, AUTHOR_ID) VALUES "
                                            + "(" + art_id + ", " + id + ");");
                    int a1 = Integer.parseInt(req.getParameter("author1"));
                    int a2 = Integer.parseInt(req.getParameter("author2"));
                    int a3 = Integer.parseInt(req.getParameter("author3"));
                    if (a1 != 0){
                        DataBaseConnection.sendUpdate("INSERT INTO ARTICLE_AUTHORS (ARTICLE_ID, AUTHOR_ID) VALUES "
                                + "(" + art_id + ", " + a1 + ");");
                    }
                    if (a2 != 0 && a2!=a1){
                        DataBaseConnection.sendUpdate("INSERT INTO ARTICLE_AUTHORS (ARTICLE_ID, AUTHOR_ID) VALUES "
                                + "(" + art_id + ", " + a2 + ");");
                    }
                    if (a3 != 0 && a2!=a3 && a3!=a1){
                        DataBaseConnection.sendUpdate("INSERT INTO ARTICLE_AUTHORS (ARTICLE_ID, AUTHOR_ID) VALUES "
                                + "(" + art_id + ", " + a3 + ");");
                    }
                }else {
                    msg = 2;
                    resp.sendRedirect("/authorMain.jsp?role=" + role + "&id=" + id + "&w=" + msg);
                }
            } catch (SQLException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                msg = 3;
                resp.sendRedirect("/authorMain.jsp?role=" + role + "&id=" + id + "&w=" + msg);
            }
            msg = 0;
        }
        resp.sendRedirect("/authorMain.jsp?role=" + role + "&id=" + id + "&w=" + msg);
    }
}
