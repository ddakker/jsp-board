<%--
  Created by IntelliJ IDEA.
  User: TRQ1
  Date: 2018. 10. 1.
  Time: AM 9:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%!
    public Connection connDb() {
        Connection conn = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            String url = "jdbc:mariadb://localhost:3306/boards";
            String userid = "root";
            String passwd = "qwer0987";
            conn = DriverManager.getConnection(url, userid, passwd);
        } catch (SQLException e) {
            System.out.println(e);
        } catch (ClassNotFoundException c) {
            System.out.println(c);
        }
        return conn;
    }

    /**
     *
     * @param pstmt
     * @param conn
     * PrepareStatement, ResultSet, Connection 종료를 위한 메소드
     */
    public void close(PreparedStatement pstmt, Connection conn) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } else if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println(e);
            }
        }

    }

    public void resultClose(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.out.println(e);
            }
        }
    }

    /**
     * SQLCount 쿼리를 위한 메소드
     */

    public int sqlCount() {
        PreparedStatement pstm = null;
        ResultSet rs = null;
        Connection conn = connDb();
        int total = 0;
        try {
            String sqlCount = "SELECT COUNT(*) FROM board";
            pstm = conn.prepareStatement(sqlCount);
            rs = pstm.executeQuery(sqlCount);

            if (rs.next()) {
                total = rs.getInt(1); // select문 count 값
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
            resultClose(rs);
        }
        return total;
    }

    /**
     * 게시판 글 패스워드를 확인 하기위한 메소드
     */
    public String sqlPasswd(int idx) {
        PreparedStatement pstm = null;
        ResultSet rs = null;
        Connection conn = connDb();
        String password = "";
        try {
            String sqlPasswd = "SELECT passwd FROM board WHERE id=" + idx;
            pstm = conn.prepareStatement(sqlPasswd);
            rs = pstm.executeQuery(sqlPasswd);

            if (rs.next()) {
                password = rs.getString(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
            resultClose(rs);
        }
        return password;
    }

    public void sqlDelete(int idx) {
        PreparedStatement pstm = null;
        Connection conn = connDb();
        try {
            String sqlDelete = "DELETE FROM board WHERE id=" + idx;
            System.out.println(sqlDelete);
            pstm = conn.prepareStatement(sqlDelete);
            pstm.executeUpdate();

        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
        }
    }

    /**
     * 게시판 정보를 읽어드리기위한 메소드
     */
    public void sqlSelect(int idx) {
        PreparedStatement pstm = null;
        ResultSet rs = null;
        Connection conn = connDb();
        String authorSelect = "";
        String titleSelect = "";
        String contentSelect = "";
        String todateSelect = "";
        try {
            String sqlSelect = "SELECT author, title, content, todate FROM board WHERE id=" + idx;
            pstm = conn.prepareStatement(sqlSelect);
            rs = pstm.executeQuery(sqlSelect);

            if (rs.next()) {
                authorSelect = rs.getString(1);
                titleSelect = rs.getString(2);
                contentSelect = rs.getString(3);
                todateSelect = rs.getString(4);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
            resultClose(rs);
        }
        return;
    }

    /**
     * sqlList를 리턴하기 위한 class
     */
    /**
     *
     * @param start
     * @param end
     * 게시판 글 리스트를 읽어드리기 위한 메소드
     */
    public void sqlList(int start, int end) {
        PreparedStatement pstm = null;
        ResultSet rs = null;
        Connection conn = connDb();
        int id = 0;
        String author = "";
        String todate = "";
        String title = "";
        String todateBefore = "";
        String checkTitle = "";
        try {
            String sqlList = "SELECT id, author, title, todate from board where id >=" + start + " and id <= " + end + " order by id DESC";
            pstm = conn.prepareStatement(sqlList);
            rs = pstm.executeQuery(sqlList);

            while (rs.next()) {
                id = rs.getInt(1);
                author = rs.getString(2);
                checkTitle = rs.getString(3);
                todateBefore = rs.getString(4);
                todate = todateBefore.substring(0, todateBefore.length() - 2); // 소수점 자르기 추후 데이터 타입 나오게 할 예정

                // checkTitle 에 200자 이상인 경우 ... 을 붙인다.
                int titleLen = checkTitle.length();

                if (titleLen > 200) { // 200 이상인 경우 titlelen 숫자에서 - 10 을 한후 뒤에 ... 을 붙인다.
                    title = checkTitle.substring(0, titleLen - 10) + "...";
                } else {
                    title = checkTitle;
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
            resultClose(rs);
        }
    }

    /**
     *
     * @param title
     * @param content
     * 게시판 글 제목 및 내용을 수정하기위한 메소드
     */
    public void sqlUpdate(String title, String content, int idx) {
        PreparedStatement pstm = null;
        Connection conn = connDb();
        try {
            String sqlUpdate = "UPDATE board SET title='" + title + "' ,content='" + content + "' WHERE id=" + idx;
            pstm = conn.prepareStatement(sqlUpdate);
            pstm.executeUpdate(sqlUpdate);
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
        }
    }

    /**
     *
     * @param authorInsert
     * @param passwordInsert
     * @param titleInsert
     * @param contentInsert
     *
     * 게시판 글을 쓰기 위한 메소드
     */
    public void sqlInsert(String authorInsert, String passwordInsert, String titleInsert, String contentInsert) {
        PreparedStatement pstm = null;
        Connection conn = connDb();
        try {
            String sqlInsert = "INSERT INTO board(author,passwd,title,content,todate) VALUES(?,?,?,?,NOW())";
            System.out.println(sqlInsert);
            pstm = conn.prepareStatement(sqlInsert);
            pstm.setString(1, authorInsert);
            pstm.setString(2, passwordInsert);
            pstm.setString(3, titleInsert);
            pstm.setString(4, contentInsert);
            pstm.execute();
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            close(pstm, conn);
        }
    }

%>
