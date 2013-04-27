package myServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created with IntelliJ IDEA.
 * User: Vasya
 * Date: 21.04.13
 * Time: 2:50
 * To change this template use File | Settings | File Templates.
 */
public class NewRevisionServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int msg;
        req.setCharacterEncoding("WINDOWS-1251");
        int id = Integer.parseInt(req.getParameter("id"));
        int role = Integer.parseInt(req.getParameter("role"));
        int articleId = Integer.parseInt(req.getParameter("articleId"));
        int conclusion = Integer.parseInt(req.getParameter("conclusion"));
        String note = req.getParameter("note");
        String date = req.getParameter("date");

        if (note.equals("") || date.equals("") || (conclusion<2 || conclusion>3)){
            msg = 1;
        } else {

            DataBaseConnection.sendUpdate("INSERT INTO REVISION VALUES "
                    + "(Null, " + articleId + ", " + id + ", '" + date + "', '" + note + "', " + conclusion + ");");
            msg = 0;
        }
        resp.sendRedirect("/aboutArticle.jsp?role=" + role + "&id=" + id + "&article=" + articleId + "&w=" + msg);
    }
}
