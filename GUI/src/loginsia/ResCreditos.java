/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JInternalFrame.java to edit this template
 */
package loginsia;

import com.academico.login.conexion.SQLConnection;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.plaf.basic.BasicInternalFrameUI;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author HUERTAS
 */
public class ResCreditos extends javax.swing.JInternalFrame {

    
    private String usuario;
    private String contrasena;
    private String programa;
    SQLConnection cc = new SQLConnection();
    private Connection conexion;
    private ResultSet rs;   
    private DefaultTableModel creditos;
    private DefaultTableModel cupo;
    
    /**
     * Creates new form ResCreditos
     */
    public ResCreditos(String usuario,String contrasena,String programa) {
        initComponents();
        this.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        BasicInternalFrameUI ui1 = (BasicInternalFrameUI) this.getUI();
        ui1.setNorthPane(null);
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.programa = programa;
        this.conexion = cc.conexion(usuario,contrasena);
        this.creditos = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        this.cupo = new DefaultTableModel(){
            @Override
            public boolean isCellEditable(int filas,int columnas){
                return false;
            }
        };
        
        creditos.addColumn("TIPOLOGÍAS");
        creditos.addColumn("EXIGIDOS");
        creditos.addColumn("APROBADOS");
        creditos.addColumn("PENDIENTES");
        creditos.addColumn("INSCRITOS");
        creditos.addColumn("CURSADOS");
        Creditos.setModel(creditos);
        
        cupo.addColumn("Créditos adicionales");
        cupo.addColumn("Cupo de créditos");
        cupo.addColumn("Creditos adicionales");
        cupo.addColumn("Créditos de doble titulación");
        
        Cupo.setModel(cupo);
        
        
        try {
            String sql = "{CALL sp_encap_resumen_creditos(?,?)}";
            CallableStatement callableStatement = conexion.prepareCall(sql);

            // Establecer los parámetros de entrada del procedimiento   
            callableStatement.setString(1, this.usuario);
            callableStatement.setString(2, this.programa);

            // Ejecutar el procedimiento almacenado
            boolean hasResults = callableStatement.execute();

            // Recorrer los resultados
            
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    String[] dato = new String[6];
                    int i;
                    for(i = 0; i <= 8;i++){
                        try {
                            resultSet.next();
                        } catch (SQLException ex) {
                            Logger.getLogger(ResCreditos.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        dato[0] = resultSet.getString("tipologia");
                        dato[1] = String.valueOf(resultSet.getInt("exigido"));
                        dato[2] = String.valueOf(resultSet.getInt("aprobado"));
                        dato[3] = String.valueOf(resultSet.getInt("pendientes"));
                        dato[4] = String.valueOf(resultSet.getInt("inscritos"));
                        dato[5] = String.valueOf(resultSet.getInt("cursados"));    
                        creditos.addRow(dato);
                    }  
                }

                // Verificar si hay más resultados disponibles
                hasResults = callableStatement.getMoreResults();
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    resultSet.next();
                    Integer[] dato = new Integer[4];
                    dato[0] = resultSet.getInt("cre_adicionales");
                    dato[1] = resultSet.getInt("cupo_creditos");
                    dato[2] = resultSet.getInt("cre_adicionales");
                    dato[3] = resultSet.getInt("cre_doble_tit");
                    cupo.addRow(dato);
                }
                
                hasResults = callableStatement.getMoreResults();
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    resultSet.next();
                    AvanceLabel.setText(String.valueOf(resultSet.getDouble("Avance")));
                    }
                
                hasResults = callableStatement.getMoreResults();
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    resultSet.next();
                    CanceladosLabel.setText(String.valueOf(resultSet.getInt("Cancelados")));
                    }
                
                hasResults = callableStatement.getMoreResults();
                if (hasResults) {
                    ResultSet resultSet = callableStatement.getResultSet();
                    resultSet.next();
                    ExcedentesLabel.setText(String.valueOf(resultSet.getInt("Excedentes")));
                    }
                    
                
                    
                    

                
        } catch (SQLException ex) {
            Logger.getLogger(Historia.class.getName()).log(Level.SEVERE, null, ex);
        }
}
        
   

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jScrollPane1 = new javax.swing.JScrollPane();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        Cupo = new javax.swing.JTable();
        jScrollPane4 = new javax.swing.JScrollPane();
        Creditos = new javax.swing.JTable();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        panelRound1 = new loginsia.PanelRound();
        AvanceLabel = new javax.swing.JLabel();
        panelRound2 = new loginsia.PanelRound();
        CanceladosLabel = new javax.swing.JLabel();
        panelRound3 = new loginsia.PanelRound();
        ExcedentesLabel = new javax.swing.JLabel();

        jTable2.setModel(new javax.swing.table.DefaultTableModel(
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
        jScrollPane2.setViewportView(jTable2);

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setPreferredSize(new java.awt.Dimension(1220, 1300));

        jLabel1.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        jLabel1.setText("Total excedentes:");

        jLabel2.setFont(new java.awt.Font("Arial", 1, 36)); // NOI18N
        jLabel2.setText("Resumen de créditos");

        Cupo.setModel(new javax.swing.table.DefaultTableModel(
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
        jScrollPane3.setViewportView(Cupo);

        Creditos.setModel(new javax.swing.table.DefaultTableModel(
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
        jScrollPane4.setViewportView(Creditos);

        jLabel3.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        jLabel3.setText("Cupo de créditos");

        jLabel4.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        jLabel4.setText("Porcentaje de avance:");

        jLabel5.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        jLabel5.setText("Total créditos cancelados:");

        panelRound1.setBackground(new java.awt.Color(96, 25, 25));
        panelRound1.setRoundBottomLeft(34);
        panelRound1.setRoundBottomRight(34);
        panelRound1.setRoundTopLeft(34);
        panelRound1.setRoundTopRight(34);

        AvanceLabel.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        AvanceLabel.setForeground(new java.awt.Color(255, 255, 255));
        AvanceLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        AvanceLabel.setText("100%");

        javax.swing.GroupLayout panelRound1Layout = new javax.swing.GroupLayout(panelRound1);
        panelRound1.setLayout(panelRound1Layout);
        panelRound1Layout.setHorizontalGroup(
            panelRound1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelRound1Layout.createSequentialGroup()
                .addGap(15, 15, 15)
                .addComponent(AvanceLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 109, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        panelRound1Layout.setVerticalGroup(
            panelRound1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelRound1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(AvanceLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 48, Short.MAX_VALUE)
                .addContainerGap())
        );

        panelRound2.setBackground(new java.awt.Color(96, 25, 25));
        panelRound2.setRoundBottomLeft(34);
        panelRound2.setRoundBottomRight(34);
        panelRound2.setRoundTopLeft(34);
        panelRound2.setRoundTopRight(34);

        CanceladosLabel.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        CanceladosLabel.setForeground(new java.awt.Color(255, 255, 255));
        CanceladosLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        CanceladosLabel.setText("XD");

        javax.swing.GroupLayout panelRound2Layout = new javax.swing.GroupLayout(panelRound2);
        panelRound2.setLayout(panelRound2Layout);
        panelRound2Layout.setHorizontalGroup(
            panelRound2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelRound2Layout.createSequentialGroup()
                .addGap(17, 17, 17)
                .addComponent(CanceladosLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 109, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        panelRound2Layout.setVerticalGroup(
            panelRound2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelRound2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(CanceladosLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 48, Short.MAX_VALUE)
                .addContainerGap())
        );

        panelRound3.setBackground(new java.awt.Color(96, 25, 25));
        panelRound3.setRoundBottomLeft(34);
        panelRound3.setRoundBottomRight(34);
        panelRound3.setRoundTopLeft(34);
        panelRound3.setRoundTopRight(34);

        ExcedentesLabel.setBackground(new java.awt.Color(255, 255, 255));
        ExcedentesLabel.setFont(new java.awt.Font("Arial", 1, 28)); // NOI18N
        ExcedentesLabel.setForeground(new java.awt.Color(255, 255, 255));
        ExcedentesLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        ExcedentesLabel.setText("65");

        javax.swing.GroupLayout panelRound3Layout = new javax.swing.GroupLayout(panelRound3);
        panelRound3.setLayout(panelRound3Layout);
        panelRound3Layout.setHorizontalGroup(
            panelRound3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, panelRound3Layout.createSequentialGroup()
                .addContainerGap(18, Short.MAX_VALUE)
                .addComponent(ExcedentesLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 109, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(16, 16, 16))
        );
        panelRound3Layout.setVerticalGroup(
            panelRound3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, panelRound3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(ExcedentesLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 48, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel3)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap(44, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 1069, Short.MAX_VALUE)
                    .addComponent(jScrollPane4))
                .addGap(107, 107, 107))
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(112, 112, 112)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5)
                    .addComponent(jLabel4)
                    .addComponent(jLabel1))
                .addGap(27, 27, 27)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(panelRound2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(panelRound1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(panelRound3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(70, 70, 70)
                    .addComponent(jLabel2)
                    .addContainerGap(790, Short.MAX_VALUE)))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(105, 105, 105)
                .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 172, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(36, 36, 36)
                .addComponent(jLabel3)
                .addGap(18, 18, 18)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(68, 68, 68)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(panelRound1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel4)))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(24, 24, 24)
                        .addComponent(jLabel5)
                        .addGap(43, 43, 43)
                        .addComponent(jLabel1))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(panelRound2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(panelRound3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(619, Short.MAX_VALUE))
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup()
                    .addGap(43, 43, 43)
                    .addComponent(jLabel2)
                    .addContainerGap(1215, Short.MAX_VALUE)))
        );

        jScrollPane1.setViewportView(jPanel1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1220, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 730, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    public javax.swing.JLabel AvanceLabel;
    private javax.swing.JLabel CanceladosLabel;
    private javax.swing.JTable Creditos;
    private javax.swing.JTable Cupo;
    private javax.swing.JLabel ExcedentesLabel;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTable jTable2;
    private loginsia.PanelRound panelRound1;
    private loginsia.PanelRound panelRound2;
    private loginsia.PanelRound panelRound3;
    // End of variables declaration//GEN-END:variables
}
