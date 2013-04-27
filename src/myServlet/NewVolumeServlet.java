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
 * Date: 21.04.13
 * Time: 22:12
 * To change this template use File | Settings | File Templates.
 */
public class NewVolumeServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("WINDOWS-1251");
        int msg;
        int id = Integer.parseInt(req.getParameter("id"));
        int role = Integer.parseInt(req.getParameter("role"));

        String[] articleIds = req.getParameterValues("articles");
        String title = req.getParameter("title");
        String date = req.getParameter("date");
        String copies = req.getParameter("copies");


        if (title.equals("") || date.equals("") || copies.equals("") || articleIds == null || articleIds.length == 0){
            msg = 1;
        } else {
            int cNum = Integer.parseInt(copies);
            DataBaseConnection.sendUpdate("INSERT INTO VOLUME VALUES "
                    + "(Null, '" + date + "', '" + title + "', " + cNum + ");");

            ResultSet resultSet = DataBaseConnection.getRecords("SELECT MAX(VOLUME_ID) FROM VOLUME ");
            try {
                if (resultSet.next()){
                    for (String str: articleIds){
                        int artId = Integer.parseInt(str);
                        System.out.println(artId);
                        DataBaseConnection.sendUpdate("UPDATE ARTICLE SET STATUS = 4, VOLUME_ID = "
                                + resultSet.getString(1) + " WHERE " + "ARTICLE_ID = " + artId + ";");
                    }
                } else {
                    msg = 3;
                }
            } catch (SQLException e) {
                msg = 3;
                e.printStackTrace();
            }
            msg = 0;
        }
        resp.sendRedirect("/editorMain.jsp?role=" + role + "&id=" + id + "&w=" + msg);

    }
}
