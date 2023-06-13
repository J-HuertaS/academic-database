/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JInternalFrame.java to edit this template
 */
package loginsia;

import com.academico.login.conexion.SQLConnection;
import java.awt.Component;
import java.awt.HeadlessException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.plaf.basic.BasicInternalFrameUI;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;

/**
 *
 * @author HUERTAS
 */
public class Horario extends javax.swing.JInternalFrame {
    
    private String usuario;
    private String contrasena;
    private String programa;
    private SQLConnection cc = new SQLConnection();
    private Connection conexion;
    private DefaultTableModel d1;
    private DefaultTableModel d2;
    private DefaultTableModel d3;
    private DefaultTableModel d4;
    private DefaultTableModel d5;
    private DefaultTableModel d6;
    private DefaultTableModel d7;
    private DefaultTableModel horario;
    
    
    /**
     * Creates new form Horario
     */
    public Horario(String usuario, String contrasena, String programa) {
        initComponents();
        
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.programa = programa;
        this.conexion = cc.conexion(usuario,contrasena);
        
        this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        BasicInternalFrameUI ui1 = (BasicInternalFrameUI) this.getUI();
        ui1.setNorthPane(null);
        jScrollPane7.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        
        this.d1 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d1.addColumn("Lunes");
        
        this.d2 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d2.addColumn("Martes");
        
        this.d3 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d3.addColumn("Miércoles");
        
        this.d4 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d4.addColumn("Jueves");
        
        this.d5 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d5.addColumn("Viernes");
        
        this.d6 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d6.addColumn("Sábado");
        
        this.d7 = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        d7.addColumn("Domingo");
        
        this.horario = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        horario.addColumn("Lunes");
        horario.addColumn("Martes");
        horario.addColumn("Miércoles");
        horario.addColumn("Jueves");
        horario.addColumn("Viernes");
        horario.addColumn("Sábado");
        horario.addColumn("Domingo");
        
        
        Thora1.setModel(horario);
        TL.setModel(d1);
        TMa.setModel(d2);
        TMi.setModel(d3);
        TJ.setModel(d4);
        TV1.setModel(d5);
        TS.setModel(d6);
        TD.setModel(d7);
        
        Thora1.setFillsViewportHeight(true);
        TL.setFillsViewportHeight(true);
        TMa.setFillsViewportHeight(true);
        TMi.setFillsViewportHeight(true);
        TJ.setFillsViewportHeight(true);
        TV1.setFillsViewportHeight(true);
        TS.setFillsViewportHeight(true);
        TD.setFillsViewportHeight(true);
        
        try {      

            CallableStatement sp1 = conexion.prepareCall("{CALL sp_horario_est(?,?)}");
            sp1.setString(1, this.usuario);
            sp1.setString(2,this.programa);
            
            boolean hasResult = sp1.execute();
            
            if (hasResult){
                String[] dato = new String[7];
                ResultSet rs = sp1.getResultSet();
                rs.next();
                Integer[] counter = new Integer[7];
                dato[0] = saltosDeLinea(rs.getString("Lunes"));
                dato[1] = saltosDeLinea(rs.getString("Martes"));
                dato[2] = saltosDeLinea(rs.getString("Miércoles"));
                dato[3] = saltosDeLinea(rs.getString("Jueves"));
                dato[4] = saltosDeLinea(rs.getString("Viernes"));
                dato[5] = saltosDeLinea(rs.getString("Sábado"));
                dato[6] = saltosDeLinea(rs.getString("Domingo"));
                counter[0] = rs.getString("Lunes").length();
                counter[1] = rs.getString("Martes").length();
                counter[2] = rs.getString("Miércoles").length();
                counter[3] = rs.getString("Jueves").length();
                counter[4] = rs.getString("Viernes").length();
                counter[5] = rs.getString("Sábado").length();
                counter[6] = rs.getString("Domingo").length();
                horario.addRow(dato);
                Integer mayor = 0;
                for (int i = 1; i < counter.length; i++) {
                    if (counter[i] > mayor) {
                        mayor = counter[i];
                    }
                }
                Thora1.setRowHeight((mayor/8) * 20);
            }
            
            hasResult = sp1.getMoreResults();

            if (hasResult){
                String[] dato1 = new String[1];
                ResultSet rs = sp1.getResultSet();
                
                while (rs.next()) {
                    dato1[0] = saltosDeLinea(rs.getString("dia"));
                    Integer celda = countO(rs.getString("dia"),'\n');
                    switch (rs.getString("info_fecha")) {
                        case "lunes" -> {
                            d1.addRow(dato1);
                            TL.setRowHeight(20*celda);
                        }
                        case "martes" -> {
                            d2.addRow(dato1);
                            TMa.setRowHeight(20*celda);
                        }
                        case "miércoles" -> {
                            d3.addRow(dato1);
                            TMi.setRowHeight(20*celda);
                        }
                        case "jueves" -> {
                            d4.addRow(dato1);
                            TJ.setRowHeight(20*celda);
                        }
                        case "viernes" -> {
                            d5.addRow(dato1);
                            TV1.setRowHeight(20*celda);
                        }
                        case "sábado" -> {
                            d6.addRow(dato1);
                            TS.setRowHeight(20*celda);
                        }
                        case "domingo" -> {
                            d7.addRow(dato1);
                            TD.setRowHeight(20*celda);
                        }
                        default -> JOptionPane.showMessageDialog(null,"Error.");
                    }
                    
                }
            }   
        } catch (HeadlessException | SQLException e) {
            JOptionPane.showMessageDialog(null,"Error: "+e.getMessage());
        }
        
        
        
        
    }
    
    private String saltosDeLinea(String descripción) {
        String convertido;
        String sinSaltos = descripción.replaceAll("\n", "<br> ");
        convertido = "<HTML>" + sinSaltos + "</HTML>";
        return convertido;
    }
    
    
    public static int countO(String str, char ch) {

        Matcher matcher = Pattern.compile(String.valueOf(ch)).matcher(str);

        int counter = 0;
        while (matcher.find()) {
            counter++;
        }

        return counter;
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        Thora = new javax.swing.JTable();
        jScrollPane7 = new javax.swing.JScrollPane();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        Thora1 = new javax.swing.JTable();
        jScrollPane3 = new javax.swing.JScrollPane();
        TL = new javax.swing.JTable();
        jLabel2 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        TMa = new javax.swing.JTable();
        jLabel3 = new javax.swing.JLabel();
        jScrollPane5 = new javax.swing.JScrollPane();
        TMi = new javax.swing.JTable();
        jLabel4 = new javax.swing.JLabel();
        jScrollPane6 = new javax.swing.JScrollPane();
        TJ = new javax.swing.JTable();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jScrollPane8 = new javax.swing.JScrollPane();
        TS = new javax.swing.JTable();
        jLabel7 = new javax.swing.JLabel();
        jScrollPane9 = new javax.swing.JScrollPane();
        TV1 = new javax.swing.JTable();
        jScrollPane10 = new javax.swing.JScrollPane();
        TD = new javax.swing.JTable();

        Thora.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane1.setViewportView(Thora);

        jScrollPane7.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jLabel1.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel1.setText("Lunes");

        Thora1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        Thora1.setGridColor(new java.awt.Color(204, 204, 204));
        jScrollPane2.setViewportView(Thora1);

        TL.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        TL.setGridColor(new java.awt.Color(255, 255, 255));
        jScrollPane3.setViewportView(TL);

        jLabel2.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel2.setText("Martes");

        TMa.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        TMa.setGridColor(new java.awt.Color(255, 255, 255));
        jScrollPane4.setViewportView(TMa);

        jLabel3.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel3.setText("Miércoles");

        TMi.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane5.setViewportView(TMi);

        jLabel4.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel4.setText("Jueves");

        TJ.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane6.setViewportView(TJ);

        jLabel5.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel5.setText("Viernes");

        jLabel6.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel6.setText("Sábado");

        TS.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane8.setViewportView(TS);

        jLabel7.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel7.setText("Domingo");

        TV1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane9.setViewportView(TV1);

        TD.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane10.setViewportView(TD);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(164, 164, 164)
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel6)
                        .addGap(427, 427, 427))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jScrollPane5)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addGap(48, 48, 48)
                                        .addComponent(jLabel3))
                                    .addComponent(jScrollPane9)
                                    .addComponent(jScrollPane10, javax.swing.GroupLayout.PREFERRED_SIZE, 491, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGroup(jPanel1Layout.createSequentialGroup()
                                    .addGap(164, 164, 164)
                                    .addComponent(jLabel1)
                                    .addGap(340, 340, 340)))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(116, 116, 116)
                                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 491, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane8, javax.swing.GroupLayout.PREFERRED_SIZE, 491, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 491, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jScrollPane6, javax.swing.GroupLayout.PREFERRED_SIZE, 491, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(48, 48, 48)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel2)
                                    .addComponent(jLabel4))))
                        .addGap(112, 112, 112))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(162, 162, 162)
                        .addComponent(jLabel7)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(91, 91, 91)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 1033, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(37, 37, 37)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 378, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addGap(28, 28, 28)
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(28, 28, 28)
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(37, 37, 37)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addGap(28, 28, 28)
                        .addComponent(jScrollPane6, javax.swing.GroupLayout.PREFERRED_SIZE, 255, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addGap(28, 28, 28)
                        .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 255, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(27, 27, 27)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jLabel6))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jScrollPane8, javax.swing.GroupLayout.PREFERRED_SIZE, 255, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane9, javax.swing.GroupLayout.PREFERRED_SIZE, 255, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(26, 26, 26)
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 53, Short.MAX_VALUE)
                .addComponent(jScrollPane10, javax.swing.GroupLayout.PREFERRED_SIZE, 176, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(279, 279, 279))
        );

        jScrollPane7.setViewportView(jPanel1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jScrollPane7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 234, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(jScrollPane7, javax.swing.GroupLayout.PREFERRED_SIZE, 750, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable TD;
    private javax.swing.JTable TJ;
    private javax.swing.JTable TL;
    private javax.swing.JTable TMa;
    private javax.swing.JTable TMi;
    private javax.swing.JTable TS;
    private javax.swing.JTable TV1;
    private javax.swing.JTable Thora;
    private javax.swing.JTable Thora1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane10;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JScrollPane jScrollPane8;
    private javax.swing.JScrollPane jScrollPane9;
    // End of variables declaration//GEN-END:variables
}
