require(shiny)
require(shinyjs)
require(shinyWidgets)
require(shinyFiles)

shinyUI(fluidPage(
  useShinyjs(),
  titlePanel("Welcome to the Stock Synthesis data-limited tool"),
      h5(p(strong("This tool uses the Stock Synthesis framework to implement the following types of models:"))),
       tags$ul(tags$li(h5(p(em("Length-based estimation of relative biomass, SPR and F."))))),
       tags$ul(tags$li(h5(p(em("Length + catch-based estimation of biomass, relativ0e biomass, SPR and F and catch limits."))))),
       tags$ul(tags$li(h5(p(em("COMING SOON: Simple Stock Synthesis (SSS) estimator of sustainable catch."))))),
       tags$ul(tags$li(h5(p(em("COMING SOON: Extended Simple Stock Synthesis (XSSS) estimator of sustainable catch."))))),
       tags$ul(tags$li(h5(p(em("COMING SOON: Abundance and catch-based estimation of biomass, relative biomass, SPR and F and catch limits."))))),
sidebarLayout(
   sidebarPanel(
shinyjs::hidden(wellPanel(id="Data_panel",
  h4(strong("Choose data file")),
  fluidRow(column(width=12,fileInput('file1', 'Length composition',
                                    accept = c(
                                      'text/csv',
                                      'text/comma-separated-values',
                                      'text/tab-separated-values',
                                      'text/plain',
                                      '.csv'
                                    )
  ))),
  fileInput('file3', 'Age composition',
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              'text/tab-separated-values',
              'text/plain',
              '.csv'
            )
          ),

 fluidRow(column(width=12,fileInput('file2', 'Catch time series',
                           accept = c(
                             'text/csv',
                             'text/comma-separated-values',
                             'text/tab-separated-values',
                             'text/plain',
                             '.csv'
                           )
  ))),
 
  #Mute for now, pull back in when index methods are ready
  # fileInput('file3', 'Abundance index',
  #           accept = c(
  #             'text/csv',
  #             'text/comma-separated-values',
  #             'text/tab-separated-values',
  #             'text/plain',
  #             '.csv'
  #           )
  #         ),
  h4(strong("Clear data files")),
     fluidRow(column(width=4,actionButton("reset_lt", "Length")),
              column(width=4,actionButton("reset_age", "Ages")),
              column(width=4,actionButton("reset_ct", "Catches"))),
)
),
    shinyjs::hidden(wellPanel(id="panel_ct_wt_LO",
        h4(strong("Weight fleet lengths by relative catch")),
        h5(em("The relative catch contribution needs specification with multiple length-only fleets")),
        h5(em("Example: Two fleets, with fleet 2 catching 2 times the amount as fleet 1, the entry would be 1,2.")),
        h5(em("Each entry will be relative to the highest value.")),
        fluidRow(column(width=10,textInput("Wt_fleet_Ct","Relative catch values",value=""))),
      )
    ),
    
    shinyjs::hidden(wellPanel(id="panel_data_wt_lt",
        h4(strong("Data-weighting")),
        h5(em("Data weighting balances information content of biological data with model structure")),
        h5(em("Data weighting balances across factors (e.g, fleets, sex, etc.)")),
        h5(em("The default value is equally weighting among factors based on input effective sample size inputs")),
        fluidRow(column(width=10,prettyCheckbox("dirichlet","Use Dirichlet weighting?",
          value=FALSE, 
          shape="curve",
          icon = icon("check"),
          animation="smooth"),
          bigger=TRUE),
          fill=TRUE),
        # h5(em("After the first run, you can check the Francis or harmonic mean methods for suggested weightings")),
        # fluidRow(column(width=6,textInput("Lt_datawts", "Lengths weights by fleet", value=""))),    
      )
    ),

    shinyjs::hidden(wellPanel(id="panel_SSLO_LH",
    h4(strong("Life history inputs")),
        wellPanel(id="panel_SSLO_fixed",
        h5(em("Female")),
        fluidRow(column(width=6,numericInput("M_f", "Natural mortality", value=NA,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("Linf_f", "Asymptotic size (Linf)", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("k_f","Growth coefficient k", value=NA,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("t0_f","Age at length 0 (t0)", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("CV_lt_f","CV at length", value=0.1,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("L50_f", "Length at 50% maturity", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("L95_f","Length at 95% maturity", value=NA,min=0, max=10000, step=0.01))),    
        # fluidRow(column(width=6,numericInput("WLa_f", "Weight-Length alpha", value=0.00001,min=0, max=10000, step=0.000000001)),
        #         column(width=6,numericInput("WLb_f","Weight-length beta", value=3,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("Fec_a", "Wt-based fec coeff", value=1,min=0, max=10000, step=-0.01)),
                column(width=6,numericInput("Fec_b","Wt-based fec exp", value=1,min=0, max=10000, step=0.01))),    
       ),

         fluidRow(column(width=10,prettyCheckbox("male_parms","Males specific values?",
          value=FALSE, 
          shape="curve",
          icon = icon("check"),
          animation="smooth"),
          bigger=TRUE),
          fill=TRUE,
          status="default"),
    #fluidRow(column(width=7, h3("Males specific values?")),column(width=2,checkboxInput("male_parms","Males specific values?",FALSE,width="150%"))),
        wellPanel(
                     uiOutput("Male_parms_inputs_label"),
                     uiOutput("Male_parms_inputs1"),
                     uiOutput("Male_parms_inputs2"),
                     uiOutput("Male_parms_inputs3"),
                     uiOutput("Male_parms_inputs4")
      ),
    )
    ),

shinyjs::hidden(wellPanel(id="panel_SS_LH_fixed_est_tog",
        
        fluidRow(column(width=10,switchInput("est_parms","Estimate parameters?",
        value=FALSE,
        onLabel = "YES",
        offLabel = "NO",
        onStatus = "success",
        offStatus = "danger"))), 

       h5("Estimating parameters is a data-based approach to determining life history values"),
       h5("Estimating parameters can also propagate parameter uncertainty into derived model outputs"),
       br(),
       h5("When estimating paramters with length and catch only models consider:"),
       tags$ul(tags$li(h5(p("It is recommended to run the model first by fixing parameters.")))),
       tags$ul(tags$li(h5(p("Then run likelihood profiles to see if the data contain any information on parameters.")))),
       tags$ul(tags$li(h5(p("Parameters that seem informed by the data (i.e., result in realistic values) are good candidates for estimation.")))),
       tags$ul(tags$li(h5(p("The most likely parameters to have information from fishery-based lengths are Linf and M.")))),
       h5("Not all parameters need be estimated. Fix parameters by turning the phase negative (e.g., -1)"),
       
)),

  shinyjs::hidden(wellPanel(id="panel_SS_LH_fixed",
    h4(strong("Life history inputs")),
        wellPanel(id="panel_SS_fixed",
        h5(em("Female")),
        fluidRow(column(width=6,numericInput("M_f_fix", "Natural mortality", value=NA,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("Linf_f_fix", "Asymptotic size (Linf)", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("k_f_fix","Growth coefficient k", value=NA,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("t0_f_fix","Age at length 0 (t0)", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("CV_lt_f_fix","CV at length", value=0.1,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("L50_f_fix", "Length at 50% maturity", value=NA,min=0, max=10000, step=0.01)),
                column(width=6,numericInput("L95_f_fix","Length at 95% maturity", value=NA,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("WLa_f_fix", "Weight-Length alpha", value=0.00001,min=0, max=10000, step=0.000000001)),
                column(width=6,numericInput("WLb_f_fix","Weight-length beta", value=3,min=0, max=10000, step=0.01))),    
        fluidRow(column(width=6,numericInput("Fec_a_fix", "Wt-based fec coeff", value=1,min=0, max=10000, step=-0.01)),
                column(width=6,numericInput("Fec_b_fix","Wt-based fec exp", value=1,min=0, max=10000, step=0.01))),    
       ),

        fluidRow(column(width=10,checkboxInput("male_parms_fix","Males specific values?",FALSE))),
    #fluidRow(column(width=7, h3("Males specific values?")),column(width=2,checkboxInput("male_parms","Males specific values?",FALSE,width="150%"))),
        wellPanel(
                     uiOutput("Male_parms_inputs_label_fix"),
                     uiOutput("Male_parms_inputs1_fix"),
                     uiOutput("Male_parms_inputs2_fix"),
                     uiOutput("Male_parms_inputs3_fix"),
                     uiOutput("Male_parms_inputs4_fix")
      ),
    )
    ),

    shinyjs::hidden(wellPanel(id="panel_SS_LH_est",
    h4(strong("Life history inputs")),
#      fluidRow(column(width=10,switchInput("est_parms2","Estimate parameters?",value=TRUE))),      
      wellPanel(id="panel_SS_est",
      h4(em("Female")),
        dropdownButton(
          selectInput("M_f_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("M_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("M_f_SD", "SD", value=0,min=0, max=10000, step=0.001),
          numericInput("M_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("skull-crossbones"), width = "300px",label="Natural mortality"
            ),
      br(),
       h5(strong("Growth")),            
       dropdownButton(
          selectInput("Linf_f_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("Linf_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("Linf_f_SD", "SD", value=0,min=0, max=10000, step=0.001),
          numericInput("Linf_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("infinity"), width = "300px",label="Linf: Asymptotic size"
          ),
     br(),
      dropdownButton(
          selectInput("k_f_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("k_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("k_f_SD", "SD", value=0,min=0, max=10000, step=0.001),
          numericInput("k_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("ruler-horizontal"), width = "300px",label="k: VB growth coefficient"
            ),
     br(),
      dropdownButton(
          selectInput("t0_f_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("t0_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("t0_f_SD", "SD", value=0,min=0, max=10000, step=0.001),
          numericInput("t0_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("baby-carriage"), width = "300px",label="t0: Age at size 0"
            ),
     br(),
       dropdownButton(
          selectInput("CV_lt_f_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("CV_lt_f_mean", "Mean", value=0.1,min=0, max=10000, step=0.001),
          numericInput("CV_lt_f_SD", "SD", value=0,min=0, max=10000, step=0.001),
          numericInput("CV_lt_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("dice"), width = "300px",label="CV at length"
            ),

    h5(strong("Maturity and weight-length relationships")),            
      fluidRow(column(width=6,numericInput("L50_f_est", "Length at 50% maturity", value=NA,min=0, max=10000, step=0.01)),
              column(width=6,numericInput("L95_f_est","Length at 95% maturity", value=NA,min=0, max=10000, step=0.01))),    
      fluidRow(column(width=6,numericInput("Fec_a_est", "Wt-based fec coeff", value=1,min=0, max=10000, step=-0.01)),
              column(width=6,numericInput("Fec_b_est","Wt-based fec exp", value=1,min=0, max=10000, step=0.01))),    
      fluidRow(column(width=6,numericInput("WLa_f_est", "Weight-Length alpha", value=0.00001,min=0, max=10000, step=0.000000001)),
              column(width=6,numericInput("WLb_f_est","Weight-length beta", value=3,min=0, max=10000, step=0.01))),    
    ),
      fluidRow(column(width=10,checkboxInput("male_parms_est","Males specific values?",FALSE))),
    #fluidRow(column(width=7, h3("Males specific values?")),column(width=2,checkboxInput("male_parms","Males specific values?",FALSE,width="150%"))),
      wellPanel(
                     uiOutput("Male_parms_inputs_label_est"),
                     uiOutput("Male_parms_inputs_M_est"),
                     uiOutput("Male_parms_inputs_space1"),
                     uiOutput("Male_parms_inputs_Growth_label"),
                     uiOutput("Male_parms_inputs_Linf_est"),
                     uiOutput("Male_parms_inputs_space2"),
                     uiOutput("Male_parms_inputs_k_est"),
                     uiOutput("Male_parms_inputs_space3"),
                     uiOutput("Male_parms_inputs_t0_est"),
                     uiOutput("Male_parms_inputs_space4"),
                     uiOutput("Male_parms_inputs_CV_est")
   #                  uiOutput("Male_parms_inputs_space5"),
   #                  uiOutput("Male_parms_inputs_CV_est")
        ),
      )
    ),

   #  shinyjs::hidden(wellPanel(id="panel_SS_est",
   #  h3("Life history inputs"),
   #    fluidRow(column(width=10,switchInput("est_parms2","Fix parameters?"))),      
   #    wellPanel(
   #    h4(em("Female")),
   #    fluidRow(column(width=6,numericInput("Nages","Max. age", value=NA,min=1, max=1000, step=1))),
   #    h5(strong("Natural mortality")),            
   #    fluidRow(column(width=4,style='padding:1px;',align="center", selectInput("M_prior","Prior type",c("lognormal","truncated normal","uniform","beta"))),
   #            column(width=3,style='padding:2px;',align="center",numericInput("M_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001)),    
   #            column(width=3,style='padding:2px;',align="center",numericInput("M_f_SD", "SD", value=0,min=0, max=10000, step=0.001)),    
   #            column(width=2,style='padding:2px;',align="center",numericInput("M_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    
   #    h5(strong("Growth")),            
   #    h5(strong("Linf")),            
   #    fluidRow(column(width=4,style='padding:1px;',align="center",selectInput("Linf_f_prior","Prior type",c("lognormal","truncated normal","uniform","beta"))),
   #            column(width=3,style='padding:2px;',align="center",numericInput("Linf_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001)),    
   #            column(width=3,style='padding:2px;',align="center",numericInput("Linf_f_SD", "SD", value=0,min=0, max=10000, step=0.001)),    
   #            column(width=2,style='padding:2px;',align="center",numericInput("Linf_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    
   # h5(strong("k")),            
   #    fluidRow(column(width=4,style='padding:2px;',selectInput("k_f_prior","Prior type",c("lognormal","truncated normal","uniform","beta"))),
   #            column(width=3,style='padding:2px;',numericInput("k_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001)),    
   #            column(width=3,style='padding:2px;',numericInput("k_f_SD", "SD", value=0,min=0, max=10000, step=0.001)),    
   #            column(width=2,style='padding:2px;',align="center",numericInput("k_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    
   #  h5(strong("t0")),            
   #    fluidRow(column(width=4,style='padding:2px;',selectInput("t0_f_prior","Prior type",c("lognormal","truncated normal","uniform","beta"))),
   #            column(width=3,style='padding:2px;',numericInput("t0_f_mean", "Mean", value=NA,min=0, max=10000, step=0.001)),    
   #            column(width=3,style='padding:2px;',numericInput("t0_f_SD", "SD", value=0,min=0, max=10000, step=0.001)),    
   #            column(width=2,style='padding:2px;',align="center",numericInput("t0_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    
   #  h5(strong("Length CV")),            
   #    fluidRow(column(width=4,style='padding:2px;',selectInput("CV_f_prior","Prior type",c("lognormal","truncated normal","uniform","beta"))),
   #            column(width=3,style='padding:2px;',numericInput("CV_f_mean", "Mean", value=0.1,min=0, max=10000, step=0.001)),    
   #            column(width=3,style='padding:2px;',numericInput("CV_f_SD", "SD", value=0,min=0, max=10000, step=0.001)),    
   #            column(width=2,style='padding:2px;',align="center",numericInput("CV_f_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    

   #  h5(strong("Maturity and weight-length relationships")),            
   #    fluidRow(column(width=6,numericInput("L50_f", "Length at 50% maturity", value=NA,min=0, max=10000, step=0.01)),
   #            column(width=6,numericInput("L95_f","Length at 95% maturity", value=NA,min=0, max=10000, step=0.01))),    
   #    fluidRow(column(width=6,numericInput("Fec_a", "Wt-based fec coeff", value=1,min=0, max=10000, step=-0.01)),
   #            column(width=6,numericInput("Fec_b","Wt-based fec exp", value=1,min=0, max=10000, step=0.01))),    
   #    fluidRow(column(width=6,numericInput("WLa_f", "Weight-Length alpha", value=0.00001,min=0, max=10000, step=0.000000001)),
   #            column(width=6,numericInput("WLb_f","Weight-length beta", value=3,min=0, max=10000, step=0.01))),    
   #  ),
   #    fluidRow(column(width=10,checkboxInput("male_parms_est","Males specific values?",FALSE))),
   #  #fluidRow(column(width=7, h3("Males specific values?")),column(width=2,checkboxInput("male_parms","Males specific values?",FALSE,width="150%"))),
   #    wellPanel(
   #                   uiOutput("Male_parms_inputs_label_est"),
   #                   uiOutput("Male_parms_inputs1_est"),
   #                   uiOutput("Male_parms_inputs2_est"),
   #                   uiOutput("Male_parms_inputs3_est"),
   #                   uiOutput("Male_parms_inputs4_est")
   #    ),
   #  )
   #  ),

    shinyjs::hidden(wellPanel(id="panel_SSS",
    h4(strong("Life history inputs")),
    h5(em("If using the uniform prior, low and high range go in the mean and SD input, respectively.")),
    wellPanel(
      h4(em("Female")),
      h5(strong("Natural mortality")),            
        dropdownButton(
          selectInput("M_prior_sss","Prior type",c("lognormal","normal","uniform","no prior")),
          numericInput("M_f_mean_sss", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("M_f_SD_sss", "SD", value=0.2,min=0, max=10000, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("skull-crossbones"), width = "300px",label="Natural mortality"
            ),
      h5(strong("Growth")),            
          dropdownButton(
          selectInput("Linf_f_prior_sss","Prior type",c("no prior","normal")),
          numericInput("Linf_f_mean_sss", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("Linf_f_SD_sss", "SD", value=0,min=0, max=10000, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("infinity"), width = "300px",label="Linf: Asymptotic size"
          ),
     br(),
      dropdownButton(
          selectInput("k_f_prior_sss","Prior type",c("no prior","normal")),
          numericInput("k_f_mean_sss", "Mean", value=NA,min=0, max=10000, step=0.001),
          numericInput("k_f_SD_sss", "SD", value=0,min=0, max=10000, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("ruler-horizontal"), width = "300px",label="k: VB growth coefficient"
            ),
     br(),
      dropdownButton(
          selectInput("t0_f_prior_sss","Prior type",c("no prior","normal")),
          numericInput("t0_f_mean_sss", "Mean", value=0,min=0, max=10000, step=0.001),
          numericInput("t0_f_SD_sss", "SD", value=0,min=0, max=10000, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("baby-carriage"), width = "300px",label="t0: Age at size 0"
            ),
    h5(em("Length CV")),            
      dropdownButton(
          selectInput("CV_lt_f_prior_sss","Prior type",c("no prior")),
          numericInput("CV_lt_f_mean_sss", "Mean", value=0.1,min=0, max=10000, step=0.001),
          numericInput("CV_lt_f_SD_sss", "SD", value=0,min=0, max=10000, step=0.001),
          circle = FALSE, right=TRUE, status = "danger", icon = icon("dice"), width = "300px",label="CV at length"
            ),
    h5(strong("Maturity and weight-length relationships")),            
      fluidRow(column(width=6,numericInput("L50_f_sss", "Length at 50% maturity", value=NA,min=0, max=10000, step=0.01)),
              column(width=6,numericInput("L95_f_sss","Length at 95% maturity", value=NA,min=0, max=10000, step=0.01))),    
      fluidRow(column(width=6,numericInput("Fec_a_sss", "Wt-based fec coeff", value=1,min=0, max=10000, step=-0.01)),
              column(width=6,numericInput("Fec_b_sss","Wt-based fec exp", value=1,min=0, max=10000, step=0.01))),    
      fluidRow(column(width=6,numericInput("WLa_f_sss", "Weight-Length alpha", value=0.00001,min=0, max=10000, step=0.000000001)),
              column(width=6,numericInput("WLb_f_sss","Weight-length beta", value=3,min=0, max=10000, step=0.01))),    
    ),
    
    fluidRow(column(width=10,checkboxInput("male_parms_SSS","Males specific values?",FALSE))),
    #fluidRow(column(width=7, h3("Males specific values?")),column(width=2,checkboxInput("male_parms_SSS","Males specific values?",FALSE,width="150%"))),
    wellPanel(
                     uiOutput("Male_parms_inputs_label_SSS"),
                     uiOutput("Male_parms_inputs_M_SSS"),
                     uiOutput("Male_parms_inputs_space1_SSS"),
                     uiOutput("Male_parms_inputs_Growth_label_SSS"),
                     uiOutput("Male_parms_inputs_Linf_SSS"),
                     uiOutput("Male_parms_inputs_space2_SSS"),
                     uiOutput("Male_parms_inputs_k_SSS"),
                     uiOutput("Male_parms_inputs_space3_SSS"),
                     uiOutput("Male_parms_inputs_t0_SSS"),
                     uiOutput("Male_parms_inputs_space4_SSS"),
                     uiOutput("Male_parms_inputs_CV_SSS")
     ),
     )
    ),

#SSS Stock status input
    shinyjs::hidden(wellPanel(id="panel_SS_stock_status",
    h4(strong("Relative stock status")),
      #wellPanel(
         fluidRow(column(width=6,numericInput("status_year", "Relative stock status year", value=NA,min=1000, max=3000, step=1))),
         dropdownButton(
          selectInput("Depl_sss_prior","Prior type",c("beta","lognormal","truncated normal","uniform","no prior")),
          numericInput("Depl_mean_sss", "Mean", value=NA,min=0.001, max=1, step=0.001),
          numericInput("Depl_SD_sss", "SD", value=0.2,min=0, max=1000, step=0.001),
          circle = FALSE, status = "danger", icon = icon("battery-half"), width = "300px",label="Relative Stock Status"
       ) 
      )
    ),  


################################
#Stock-recruitment/Productivity#
################################

    shinyjs::hidden(wellPanel(id="panel_SSS_prod",
    h4(strong("Stock-recruitment parameters")),
          dropdownButton(
          selectInput("h_prior_sss","Steepness",c("symmetric beta","beta","truncated normal","truncated lognormal","uniform","no prior")),
          numericInput("h_mean_sss", "Mean", value=0.7,min=0.2, max=1, step=0.001),
          numericInput("h_SD_sss", "SD", value=0.15,min=0, max=10000, step=0.001),
          circle = FALSE, status = "danger", icon = icon("recycle"), width = "300px",label="Steepness"
       ) 
      )
    ),  

    shinyjs::hidden(wellPanel(id="panel_SS_LO_prod",
    h4(strong("Stock-recruitment parameters")),
   #   wellPanel(
     fluidRow(column(width=6,numericInput("h_LO","Steepness", value=0.7,min=0.2, max=1, step=0.01))),
   #    ),
      )
    ),  

    shinyjs::hidden(wellPanel(id="panel_SS_prod_fixed",
    h4(strong("Stock-recruitment parameters")),
   #   wellPanel(
     fluidRow(column(width=6,numericInput("h","Steepness", value=0.7,min=0.2, max=1, step=0.01)),
      column(width=6,numericInput("lnR0", "Initial recruitment (lnR0)", value=9,min=0, max=20, step=0.01))),
   #    ),
      )
    ),  

    shinyjs::hidden(wellPanel(id="panel_SS_prod_est",
    h4(strong("Stock-recruitment parameters")),
     # wellPanel(
       dropdownButton(
          selectInput("h_ss_prior","Prior type",c("no prior","symmetric beta", "beta","lognormal","gamma","normal")),
          numericInput("h_mean_ss", "Mean", value=0.7,min=0.2, max=1, step=0.001),
          numericInput("h_SD_ss", "SD", value=0.15,min=0, max=10000, step=0.001),
          numericInput("h_phase", "Phase", value=-1,min=-999, max=10, step=0.001),
          circle = FALSE, status = "danger", icon = icon("recycle"), width = "300px",label="Steepness"
       ) 
  )), 

    #      fluidRow(column(width=4,style='padding:1px;',align="center", selectInput("h_ss_prior","Steepness",c("beta","symmetric beta","truncated normal","trunc lognormal","uniform"))),
    #           column(width=3,style='padding:2px;',align="center",numericInput("h_mean_ss", "Mean", value=0.7,min=0, max=10000, step=0.001)),    
    #           column(width=3,style='padding:2px;',align="center",numericInput("h_SD_ss", "SD", value=0.15,min=0, max=10000, step=0.001)), 
    #           column(width=2,style='padding:2px;',align="center",numericInput("h_phase", "Phase", value=-1,min=-999, max=10, step=0.001))),    
    #      fluidRow(column(width=6,numericInput("lnR0_est", "Initial recruitment (lnR0)", value=9,min=0, max=20, step=0.01))),
    #   #  ),
    #   )
    # ),  



   #Recruitment estimation
    shinyjs::hidden(wellPanel(id="panel_SS_recdevs",
    fluidRow(column(width=10,checkboxInput("rec_choice","Estimate recruitment?",FALSE))),
    wellPanel(
    #          fluidRow(column(width=8,offset=-10, h3("Estimate recruitment?")),column(width=6,checkboxInput("rec_choice","",FALSE))),
    #          fluidRow(column(width=8, h3("Estimate recruitment?")),column(width=4,radioButtons("rec_choice","",FALSE))),
   tags$style("
       .checkbox { /* checkbox is a div class*/
       #  line-height: 10px;
         margin-bottom: 0px; 
        margin-left: 0px;
        font-size: 20px;
       }
      input[type='checkbox']{ /* style for checkboxes */
          width: 20px; /*Desired width*/
          height: 20px; /*Desired height*/
          line-height: 100px; 
        
        # span { 
        #   margin-left: 30px;  /*set the margin, so boxes don't overlap labels*/
        #   line-height: 30px; 
      }

       }"),
                   uiOutput("Rec_options1"),
                   uiOutput("Rec_options2"),
                  fluidRow(column(width=10,checkboxInput("biasC_choice","Bias correct recruitments?",FALSE))),
                   h5("Years of no bias correction"),
                   uiOutput("Rec_options3"),
                   h5("Years of bias correction"),
                   uiOutput("Rec_options4"),
                   uiOutput("Rec_options5") 
                ),
        )
     ),

#Selectivity
    shinyjs::hidden(wellPanel(id="panel_selectivity",
  #   wellPanel(
    h4(strong("Selectivity")),
    h5("Enter parameter and phase values for each fleet and survey."), 
    h5("Example using 50% selectivity with two fleets: Inputs could be 35,40 and 2,2 for starting values and phases respectively."),
    h5("The phase input indicates estimated parameters. To fix the parameter, set the phase value to a negative number."),
    p("If using a mix of logistic and dome-shaped selectivities, select", strong("dome-shaped"),"and fix (i.e., use a negative phase) the provided default values to achieve a logistic shape for any given fleet."),
    br(),
    fluidRow(selectInput("Sel_choice","Length selectivity type",c("Logistic","Dome-shaped"))),
    # fluidRow(column(width=6,numericInput("Sel50", "Length at 50% Selectivity", value=NA,min=0, max=10000, step=0.01)),
    #         column(width=6,numericInput("Sel50_phase","Estimation phase", value=1,min=-1000, max=10, step=1))),   
    # fluidRow(column(width=6,numericInput("Selpeak", "Length at Peak Selectvity", value=NA,min=0, max=10000, step=0.01)),
    #         column(width=6,numericInput("Selpeak_phase","Estimation phase", value=1,min=-1000, max=10, step=1))),   
              #if(input$Sel_choice=="Logistic")
              #  {uiOutput("Sel_logistic")},
              #if(input$Sel_choice=="Dome-shaped")
              #  {uiOutput("Sel_domed")}
       uiOutput("Sel_parms1"),
       uiOutput("Sel_parms2"),
       uiOutput("Sel_parms3"),
       uiOutput("Sel_parms4"),
       uiOutput("Sel_parms5")
       
  #      ),
      )
   ), 

    #Jitter inputs
#    shinyjs::hidden(wellPanel(id="panel_SS_jitter1",
    shinyjs::hidden(wellPanel(id="panel_SS_jitter",
     fluidRow(column(width=10,checkboxInput("jitter_choice","Jitter starting values?",FALSE))),
              uiOutput("Jitter_value"),
              h5("Jittering refers to changing the input starting values."),
              h5("Jittering provides a quick way to adjust starting values for two main purposes:"),
                tags$ul(tags$li(h5(p("Start the model at different values to assist model convergence.")))),
                tags$ul(tags$li(h5(p("Validate global versus local model convergence. This requires running many models at different jittered starting values to make sure a lower minimized likelihood value is not found. If a lower likelihood value is found, that would be considered the best fit model.")))),
              h5("Run just 1 jitter value to find a converged model. Then run multiple jittered models to confrim that model is the best fit model."),
          )
      ),

    #Reference Points
     shinyjs::hidden(wellPanel(id="panel_RPs",
     fluidRow(column(width=10,checkboxInput("RP_choices","Define reference points?",FALSE))),
          uiOutput("RP_selection1"),
          uiOutput("RP_selection2")
          )
        ),
     
  #Forecast options
    shinyjs::hidden(wellPanel(id="panel_Forecasts",
    fluidRow(column(width=10,checkboxInput("Forecast_choice","Define forecasts?",FALSE))),
          uiOutput("Forecasts")
        )
        ),

    shinyjs::hidden(wellPanel(id="panel_Mod_dims",
    h4(strong("Model dimensions: years and ages")),
    h5(p(em("Starting year values based on inputs"))),
      tags$ul(tags$li(h5(p(em("If catch data is used, starting and ending model years are based on the time series of catch"))))),
      tags$ul(tags$li(h5(p(em("If using only length or age data, starting model year is based on earliest year minus age at 95% Linf"))))),
    # h5(p(em("Start year recommendations are:"))),
    #   tags$ul(tags$li(h5(p(em("If length data only, count the year back from the first year of length data based on maximum age likely contained in length data"))))),
    #   tags$ul(tags$li(h5(p(em("If using catch data, use the first year of catches"))))),
    # h5(p(em(""))),
      uiOutput("Model_dims1"),
    #  uiOutput("Model_dims2"),
      )
    ),
   
   #SSS iterations
    shinyjs::hidden(wellPanel(id="panel_SSS_reps",
    fluidRow(column(width=10,numericInput("SSS_reps", "Number of SSS iterations", value=1000,min=1, max=1000000, step=1)))
            )
        ),

    #wellPanel(
    shinyjs::hidden(awesomeRadio(
      inputId = "OS_choice",
      label = "Which OS?", 
      choices = c("Windows","Mac","Linux"),
      selected = "Windows",
      inline=TRUE,
      status = "warning")),
    #), 

    shinyjs::hidden(wellPanel(id="Scenario_panel",
    h4(strong("Scenario name")),
    fluidRow(column(width=8,textInput("Scenario_name", strong("Choose the name of your scenario"), value="Scenario 1"))),
    h5(p(em("Each scenario folder is saved. Changing the scenario name therefore creates a new folder of results."))),
    h5(p(em("Using different scenario names when changing data or parameter values allows easy sensitivity exploration."))),
    h5(p(em(""))),
      )
      ),

      shinyjs::hidden(actionButton("run_SS",strong("Run Model"),
      width="100%",
      icon("play-circle"),
      style="font-size:120%;border:2px solid;color:#FFFFFF;background:#658D1B")),

      shinyjs::hidden(actionButton("run_SSS",strong("Run SSS"),
      width="100%",
      icon("play-circle"),
      style="font-size:120%;border:2px solid;color:#FFFFFF; background:#236192")),
  
  

  shinyjs::hidden(wellPanel(id="Sensi_Comparison_panel",
    h4(strong("Sensitivity comparison plots")),
    h5(em("Comparing models offers insight into how changing data or model specification change model outputs.")),
    h5(em("To make these comparisons, choose first the directory containing models, then the models to compare.")),
    h5(em("A time series plot of comparisons are made for the follwing model outputs:")),  
    tags$ul(tags$li(h5(p(em("Spawning output"))))),
    tags$ul(tags$li(h5(p(em("Relative spawning output"))))),
    tags$ul(tags$li(h5(p(em("Recruitment"))))),
    h5(em("Current comparison plot is presented on the right.")), 
    h5(em("All plots are saved in the chosen directory in a folder labeled")),  
    h5(strong(em("Sensitivity Comparison Plots"))),
    br(),
    h5(strong("Choose folder containing model scenarios")),
    shinyDirButton(
      id="Sensi_dir",
      label="Select directory",
      title="Choose folder containing model scenarios"
      ),
    br(),
    br(),
    #h4(strong("Comparison plot label")),
    fluidRow(column(width=8,textInput("Sensi_comp_file", strong("Label comparison plot file"), value="Comparison 1"))),
    #br(),
    uiOutput("Sensi_model_picks"),
    #br(),
    actionButton("run_Sensi_comps",strong("Run Sensitivity Comparisons"),
        width="100%",
        icon("play-circle"),
        style="font-size:120%;border:2px solid;color:#FFFFFF; background:#236192"),  
  )),


  shinyjs::hidden(wellPanel(id="Ensemble_panel",
    h4(strong("Ensemble modelling")),
    h5(em("Ensemble modelling allows the user to combine multiple models into one weighted distribution of outputs.")),
    h5(em("User first chooses the models to combine, then how to combine them via model weights.")),
    h5(em("For example, if 3 models are chosen, weights of 1,1,1 defines equal weights.")),
    h5(em("If the middle model should have twice the weight of the others, 1,2,1 is the weighting input.")),
    br(),
    h5(strong("Choose folder containing models to combine")),
    h5(em("")),
    shinyDirButton(
      id="Ensemble_dir",
      label="Select directory",
      title="Choose folder containing models to combine"
      ),
    br(),
    br(),
    #h4(strong("Ensemble label")),
    fluidRow(column(width=8,textInput("Ensemble_file", strong("Label ensemble model file"), value="Ensemble 1"))),
    uiOutput("Ensemble_model_picks"),
    fluidRow(column(width=10,textInput("Ensemble_wts","Relative scenario weights",value=""))),
    actionButton("run_Ensemble",strong("Create Ensemble Model"),
        width="100%",
        icon("play-circle"),
        style="font-size:120%;border:2px solid;color:#FFFFFF; background:#236192"),  
  )),

  ),

###########################################
###########################################
###########################################

      mainPanel(        
        tabsetPanel(id="tabs",
            tabPanel("Data and Parameters",
              textOutput("lt_comp_plots_label"),
              plotOutput("Ltplot"),
              textOutput("age_comp_plots_label"),
              plotOutput("Ageplot"),
              textOutput("catch_comp_plots_label"),
              plotOutput("Ctplot"),
            h4("Life history"),
            column(6,plotOutput("Mplot")),
            column(6,plotOutput("VBGFplot")),
                  value=1),       
          tabPanel("Model output",
            h4("Checking model convergence. Check also fit to length composition data"),
            tableOutput("converge.grad"),
            tableOutput("converge.covar"),
            tableOutput("converge.dec"),
            tags$head(tags$style("#converge.grad{color: black;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                         )
              ),
            tags$head(tags$style("#converge.dec{color: green;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
                         )
              ),
            br(),
            h4("Relative spawning output"),
            tableOutput("SSout_relSB_table"),
            br(),
            h4("Fishing intensity"),
            tableOutput("SSout_F_table"),
            br(),
            h4("Estimated parameters"),
            tableOutput("Parameters_table"),
            br(),
            h4("Time series"),
            tableOutput("SSout_table"),
            value=2),
          tabPanel("Jitter exploration",
            plotOutput("Jitterplot"),
            h4("Blue values indicate minimum likelihood values; red indicate values higher than the minimum."),  
            h4("Any iteration with a blue value can be used as the new best-fit (reference) model."), 
            plotOutput("Jittercompplot1"),
            h4("Comparison of spawning output among jittered models. Model 0 is the initial model; numbered models are the sequential jittered models."),
            plotOutput("Jittercompplot2"),
            h4("Comparison of relative stock status among jittered models. Model 0 is the initial model; numbered models are the sequential jittered models."),
            value=3),
          tabPanel("Likelihood profile",
            
            value=4),
          tabPanel("Sensitivity comparisons",
            # uiOutput("Sensi_comp_plot"),            
            imageOutput("Sensi_comp_plot"),            
            value=5),
          tabPanel("Ensemble models",
            plotOutput("Ensemble_plots"),            
            value=6)
          ) 
   )
   )
)
)

