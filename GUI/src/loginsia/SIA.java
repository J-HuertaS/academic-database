/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package loginsia;

import java.awt.BasicStroke;
import java.awt.Color;
import javax.swing.BorderFactory;

/**
 *
 * @author HUERTAS
 */
public class SIA extends javax.swing.JFrame { 

    private String usuario;
    private String contrasena;
    private int xMouse,yMouse;

    /**
     * Creates new form SIA
     */
    public SIA(String usuario, String contrasena) {
        initComponents();
        this.usuario = usuario;
        this.contrasena = contrasena;
        Lateral.setBorder(BorderFactory.createStrokeBorder(new BasicStroke(4.0f)));
        this.setLocationRelativeTo(null);
        Welcome wl = new Welcome();
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(wl);
        wl.setVisible(true);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        Encabezado = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        Lateral = new javax.swing.JPanel();
        BBuscadorCursos = new javax.swing.JToggleButton();
        BDatosPersonales = new javax.swing.JToggleButton();
        BHistoria = new javax.swing.JToggleButton();
        BCreditos = new javax.swing.JToggleButton();
        BInicio = new javax.swing.JToggleButton();
        BInscripcion = new javax.swing.JToggleButton();
        BHome = new loginsia.PanelRound();
        Home = new javax.swing.JLabel();
        BHorario = new javax.swing.JToggleButton();
        Pantalla = new loginsia.PanelRound();
        Ventana = new javax.swing.JDesktopPane();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);
        setResizable(false);

        jPanel1.setBackground(new java.awt.Color(217, 217, 217));
        jPanel1.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(96, 25, 25), 1, true));

        Encabezado.setBackground(new java.awt.Color(96, 25, 25));
        Encabezado.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                EncabezadoMouseDragged(evt);
            }
        });
        Encabezado.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                EncabezadoMousePressed(evt);
            }
        });
        Encabezado.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jLabel1.setBackground(new java.awt.Color(255, 255, 255));
        jLabel1.setFont(new java.awt.Font("Arial", 1, 53)); // NOI18N
        jLabel1.setForeground(new java.awt.Color(255, 255, 255));
        jLabel1.setText("M ó d u l o     a c a d é m i c o                                         U  N  A  L");
        Encabezado.add(jLabel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 10, 1630, -1));

        Lateral.setBackground(new java.awt.Color(217, 217, 217));
        Lateral.setForeground(new java.awt.Color(96, 25, 25));

        BBuscadorCursos.setBackground(new java.awt.Color(96, 25, 25));
        BBuscadorCursos.setFont(new java.awt.Font("Arial", 1, 25)); // NOI18N
        BBuscadorCursos.setForeground(new java.awt.Color(255, 255, 255));
        BBuscadorCursos.setText("<html><center><p>Buscador de</p><p>cursos</p></center></html>");
        BBuscadorCursos.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        BBuscadorCursos.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BBuscadorCursosMouseClicked(evt);
            }
        });
        BBuscadorCursos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BBuscadorCursosActionPerformed(evt);
            }
        });

        BDatosPersonales.setBackground(new java.awt.Color(96, 25, 25));
        BDatosPersonales.setFont(new java.awt.Font("Arial", 1, 24)); // NOI18N
        BDatosPersonales.setForeground(new java.awt.Color(255, 255, 255));
        BDatosPersonales.setText("Datos personales");
        BDatosPersonales.setRequestFocusEnabled(false);
        BDatosPersonales.setRolloverEnabled(false);
        BDatosPersonales.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BDatosPersonalesMouseClicked(evt);
            }
        });
        BDatosPersonales.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BDatosPersonalesActionPerformed(evt);
            }
        });

        BHistoria.setBackground(new java.awt.Color(96, 25, 25));
        BHistoria.setFont(new java.awt.Font("Arial", 1, 24)); // NOI18N
        BHistoria.setForeground(new java.awt.Color(255, 255, 255));
        BHistoria.setText("Historia académica");
        BHistoria.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BHistoriaMouseClicked(evt);
            }
        });
        BHistoria.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BHistoriaActionPerformed(evt);
            }
        });

        BCreditos.setBackground(new java.awt.Color(96, 25, 25));
        BCreditos.setFont(new java.awt.Font("Arial", 1, 22)); // NOI18N
        BCreditos.setForeground(new java.awt.Color(255, 255, 255));
        BCreditos.setText("Resumén de créditos");
        BCreditos.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BCreditosMouseClicked(evt);
            }
        });

        BInicio.setBackground(new java.awt.Color(96, 25, 25));
        BInicio.setFont(new java.awt.Font("Arial", 1, 24)); // NOI18N
        BInicio.setForeground(new java.awt.Color(255, 255, 255));
        BInicio.setText("Cerrar Sesión");
        BInicio.setToolTipText("");
        BInicio.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BInicioMouseClicked(evt);
            }
        });
        BInicio.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BInicioActionPerformed(evt);
            }
        });

        BInscripcion.setBackground(new java.awt.Color(96, 25, 25));
        BInscripcion.setFont(new java.awt.Font("Arial", 1, 25)); // NOI18N
        BInscripcion.setForeground(new java.awt.Color(255, 255, 255));
        BInscripcion.setText("<html><center><p>Proceso de</p><p>inscripción</p></center></html>\n");
        BInscripcion.setToolTipText("");
        BInscripcion.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BInscripcionMouseClicked(evt);
            }
        });
        BInscripcion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BInscripcionActionPerformed(evt);
            }
        });

        BHome.setBackground(new java.awt.Color(96, 25, 25));
        BHome.setRoundBottomLeft(150);
        BHome.setRoundBottomRight(150);
        BHome.setRoundTopLeft(150);
        BHome.setRoundTopRight(150);
        BHome.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                BHomeMouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                BHomeMouseExited(evt);
            }
        });

        Home.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagenes/home.png"))); // NOI18N
        Home.setText("jLabel2");
        Home.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                HomeMouseClicked(evt);
            }
        });

        javax.swing.GroupLayout BHomeLayout = new javax.swing.GroupLayout(BHome);
        BHome.setLayout(BHomeLayout);
        BHomeLayout.setHorizontalGroup(
            BHomeLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, BHomeLayout.createSequentialGroup()
                .addContainerGap(22, Short.MAX_VALUE)
                .addComponent(Home, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(16, 16, 16))
        );
        BHomeLayout.setVerticalGroup(
            BHomeLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(BHomeLayout.createSequentialGroup()
                .addGap(17, 17, 17)
                .addComponent(Home, javax.swing.GroupLayout.PREFERRED_SIZE, 97, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(21, Short.MAX_VALUE))
        );

        BHorario.setBackground(new java.awt.Color(96, 25, 25));
        BHorario.setFont(new java.awt.Font("Arial", 1, 24)); // NOI18N
        BHorario.setForeground(new java.awt.Color(255, 255, 255));
        BHorario.setText("Mi horario");
        BHorario.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BHorarioMouseClicked(evt);
            }
        });

        javax.swing.GroupLayout LateralLayout = new javax.swing.GroupLayout(Lateral);
        Lateral.setLayout(LateralLayout);
        LateralLayout.setHorizontalGroup(
            LateralLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LateralLayout.createSequentialGroup()
                .addGroup(LateralLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(LateralLayout.createSequentialGroup()
                        .addGap(19, 19, 19)
                        .addGroup(LateralLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(BInscripcion, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BCreditos, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BHistoria, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BDatosPersonales, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BBuscadorCursos, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BHorario, javax.swing.GroupLayout.PREFERRED_SIZE, 292, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(LateralLayout.createSequentialGroup()
                        .addGap(96, 96, 96)
                        .addComponent(BHome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(LateralLayout.createSequentialGroup()
                        .addGap(59, 59, 59)
                        .addComponent(BInicio, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(20, Short.MAX_VALUE))
        );
        LateralLayout.setVerticalGroup(
            LateralLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LateralLayout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addComponent(BDatosPersonales, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(BHistoria, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(23, 23, 23)
                .addComponent(BCreditos, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(28, 28, 28)
                .addComponent(BHorario, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(28, 28, 28)
                .addComponent(BInscripcion, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(BBuscadorCursos, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(50, 50, 50)
                .addComponent(BHome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(27, 27, 27)
                .addComponent(BInicio, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(33, Short.MAX_VALUE))
        );

        Pantalla.setBackground(new java.awt.Color(255, 255, 255));
        Pantalla.setRoundBottomLeft(35);
        Pantalla.setRoundBottomRight(35);
        Pantalla.setRoundTopLeft(35);
        Pantalla.setRoundTopRight(35);

        Ventana.setBackground(new java.awt.Color(255, 255, 255));
        Ventana.setPreferredSize(new java.awt.Dimension(1220, 754));

        javax.swing.GroupLayout VentanaLayout = new javax.swing.GroupLayout(Ventana);
        Ventana.setLayout(VentanaLayout);
        VentanaLayout.setHorizontalGroup(
            VentanaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 1220, Short.MAX_VALUE)
        );
        VentanaLayout.setVerticalGroup(
            VentanaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 754, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout PantallaLayout = new javax.swing.GroupLayout(Pantalla);
        Pantalla.setLayout(PantallaLayout);
        PantallaLayout.setHorizontalGroup(
            PantallaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, PantallaLayout.createSequentialGroup()
                .addContainerGap(36, Short.MAX_VALUE)
                .addComponent(Ventana, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(33, 33, 33))
        );
        PantallaLayout.setVerticalGroup(
            PantallaLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PantallaLayout.createSequentialGroup()
                .addGap(23, 23, 23)
                .addComponent(Ventana, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(26, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(Encabezado, javax.swing.GroupLayout.DEFAULT_SIZE, 1689, Short.MAX_VALUE)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(Lateral, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(Pantalla, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(31, 31, 31))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(Encabezado, javax.swing.GroupLayout.PREFERRED_SIZE, 89, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(Lateral, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(27, 27, 27)
                        .addComponent(Pantalla, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void BInscripcionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BInscripcionActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_BInscripcionActionPerformed

    private void BDatosPersonalesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BDatosPersonalesActionPerformed
        
    }//GEN-LAST:event_BDatosPersonalesActionPerformed

    private void BHistoriaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BHistoriaActionPerformed
        
    }//GEN-LAST:event_BHistoriaActionPerformed

    private void BBuscadorCursosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BBuscadorCursosActionPerformed

    }//GEN-LAST:event_BBuscadorCursosActionPerformed

    private void BHomeMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BHomeMouseEntered
        BHome.setBackground(new Color(171,33,33));
    }//GEN-LAST:event_BHomeMouseEntered

    private void BHomeMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BHomeMouseExited
        BHome.setBackground(new Color(96,25,25));
    }//GEN-LAST:event_BHomeMouseExited

    private void EncabezadoMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_EncabezadoMouseDragged
        int x = evt.getXOnScreen();
        int y = evt.getYOnScreen();
        this.setLocation(x-xMouse,y-yMouse);
    }//GEN-LAST:event_EncabezadoMouseDragged

    private void EncabezadoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_EncabezadoMousePressed
        xMouse = evt.getX();
        yMouse = evt.getY();
    }//GEN-LAST:event_EncabezadoMousePressed

    private void BInscripcionMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BInscripcionMouseClicked
        BInscripcion.doClick(30);
        SeleccionCarrera2 select = new SeleccionCarrera2(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(select);
        select.setVisible(true);
    }//GEN-LAST:event_BInscripcionMouseClicked

    private void BDatosPersonalesMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BDatosPersonalesMouseClicked
        BDatosPersonales.doClick(30);
        PersonalData data = new PersonalData(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(data);
        data.setVisible(true);
       
    }//GEN-LAST:event_BDatosPersonalesMouseClicked

    private void BHistoriaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BHistoriaMouseClicked
        BHistoria.doClick(30);
        SeleccionCarrera select = new SeleccionCarrera(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(select);
        select.setVisible(true);
        select.titleLabel.setText("Historia Académica");
    }//GEN-LAST:event_BHistoriaMouseClicked

    private void BCreditosMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BCreditosMouseClicked
        BCreditos.doClick(30);
        SeleccionCarrera select = new SeleccionCarrera(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(select);
        select.setVisible(true);
        select.titleLabel.setText("Resumen de créditos");
    }//GEN-LAST:event_BCreditosMouseClicked

    private void BInicioMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BInicioMouseClicked
        BInicio.doClick(30);
    }//GEN-LAST:event_BInicioMouseClicked

    private void BBuscadorCursosMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BBuscadorCursosMouseClicked
        BBuscadorCursos.doClick(30);
        FiltrarCursos buscador_cursos = new FiltrarCursos(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(buscador_cursos);
        buscador_cursos.setVisible(true);
    }//GEN-LAST:event_BBuscadorCursosMouseClicked

    private void HomeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_HomeMouseClicked
        Welcome wl = new Welcome();
        Ventana.removeAll();
        Ventana.add(wl);
        wl.setVisible(true);
    }//GEN-LAST:event_HomeMouseClicked

    private void BHorarioMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BHorarioMouseClicked
        BHorario.doClick(30);
        SeleccionarCarrera1 select = new SeleccionarCarrera1(this.usuario,this.contrasena);
        Ventana.removeAll();
        Ventana.updateUI();
        Ventana.add(select);
        select.setVisible(true);
        select.titleLabel.setText("Mi horario");
    }//GEN-LAST:event_BHorarioMouseClicked

    private void BInicioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BInicioActionPerformed
        Login log = new Login();
        log.setVisible(true);
        this.dispose();
    }//GEN-LAST:event_BInicioActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(SIA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(SIA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(SIA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(SIA.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new SIA("currutiab","JFDhtr78").setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JToggleButton BBuscadorCursos;
    private javax.swing.JToggleButton BCreditos;
    private javax.swing.JToggleButton BDatosPersonales;
    private javax.swing.JToggleButton BHistoria;
    private loginsia.PanelRound BHome;
    private javax.swing.JToggleButton BHorario;
    private javax.swing.JToggleButton BInicio;
    private javax.swing.JToggleButton BInscripcion;
    private javax.swing.JPanel Encabezado;
    private javax.swing.JLabel Home;
    private javax.swing.JPanel Lateral;
    private loginsia.PanelRound Pantalla;
    public static javax.swing.JDesktopPane Ventana;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    // End of variables declaration//GEN-END:variables


}

