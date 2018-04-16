# Note: The vacols_sequence_id column maps to the ISSUE table ISSSEQ column in VACOLS
# Using this and the appeal's vacols_id, we can directly map a Caseflow issue back to its
# VACOLS' equivalent
#
# rubocop:disable Metrics/ClassLength
class Issue
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :vacols_sequence_id, :codes, :disposition, :readable_disposition, :close_date, :note

  # Labels are only loaded if we run the joins to ISSREF and VFTYPES (see VACOLS::CaseIssue)
  attr_writer :labels
  def labels
    fail Caseflow::Error::AttributeNotLoaded if @labels == :not_loaded
    @labels
  end

  attr_writer :cavc_decisions
  def cavc_decisions
    # This should probably always be preloaded to avoid each issue triggering an additional VACOLS query.
    @cavc_decisions ||= CAVCDecision.repository.cavc_decisions_by_issue(id, vacols_sequence_id)
  end

  AOJ_FOR_PROGRAMS = {
    vba: [
      :vba_burial,
      :compensation,
      :education,
      :insurance,
      :loan_guaranty,
      :pension,
      :vre,
      :fiduciary
    ],
    vha: [
      :medical
    ],
    nca: [
      :nca_burial
    ]
  }.freeze

  DIAGNOSTIC_CODE_DESCRIPTIONS = {
    "5000" => "osteomyelitis",
    "5001" => "tuberculosis of bones and joints",
    "5002" => "rheumatoid arthritis",
    "5003" => "degenerative arthritis",
    "5004" => "gonorrheal arthritis",
    "5005" => "pneumococcic arthritis",
    "5006" => "typhoid arthritis",
    "5007" => "syphilitic arthritis",
    "5008" => "streptococcic arthritis",
    "5009" => "arthritis",
    "5010" => "arthritis due to trauma",
    "5011" => "caisson disease of bones",
    "5012" => "malignant bone growth",
    "5013" => "osteoporosis",
    "5014" => "osteomalacia",
    "5015" => "benign bone growth",
    "5016" => "osteitis deformans",
    "5017" => "gout",
    "5018" => "intermittent hydrarthrosis",
    "5019" => "bursitis",
    "5020" => "synovitis",
    "5021" => "myositis",
    "5022" => "periostitis",
    "5023" => "myositis ossificans",
    "5024" => "tenosynovitis",
    "5025" => "fibromyalgia",
    "5051" => "shoulder replacement",
    "5052" => "elbow replacement",
    "5053" => "wrist replacement",
    "5054" => "hip replacement",
    "5055" => "knee replacement",
    "5056" => "ankle replacement",
    "5099" => "musculoskeletal disease",
    "5104" => "loss of hand and loss of use of foot",
    "5105" => "loss of foot and loss of use of hand",
    "5106" => "loss of both hands",
    "5107" => "loss of both feet",
    "5108" => "loss of hand and foot",
    "5109" => "loss of use of both hands",
    "5110" => "loss of use of both feet",
    "5111" => "loss of use of hand and foot",
    "5120" => "amputation of arm",
    "5121" => "amputation of arm",
    "5122" => "amputation of arm",
    "5123" => "amputation of forearm",
    "5124" => "amputation of forearm",
    "5125" => "loss of use of hand",
    "5126" => "amputation of fingers",
    "5127" => "amputation of fingers",
    "5128" => "amputation of fingers",
    "5129" => "amputation of fingers",
    "5130" => "amputation of fingers",
    "5131" => "amputation of fingers",
    "5132" => "amputation of fingers",
    "5133" => "amputation of fingers",
    "5134" => "amputation of fingers",
    "5135" => "amputation of fingers",
    "5136" => "amputation of fingers",
    "5137" => "amputation of fingers",
    "5138" => "amputation of fingers",
    "5139" => "amputation of fingers",
    "5140" => "amputation of fingers",
    "5141" => "amputation of fingers",
    "5142" => "amputation of fingers",
    "5143" => "amputation of fingers",
    "5144" => "amputation of fingers",
    "5145" => "amputation of fingers",
    "5146" => "amputation of fingers",
    "5147" => "amputation of fingers",
    "5148" => "amputation of fingers",
    "5149" => "amputation of fingers",
    "5150" => "amputation of fingers",
    "5151" => "amputation of fingers",
    "5152" => "amputation of thumb",
    "5153" => "amputation of finger",
    "5154" => "amputation of finger",
    "5155" => "amputation of finger",
    "5156" => "amputation of finger",
    "5160" => "amputation of thigh",
    "5161" => "amputation of thigh",
    "5162" => "amputation of thigh",
    "5163" => "amputation of leg",
    "5164" => "amputation of leg",
    "5165" => "amputation of leg",
    "5166" => "amputation of forefoot",
    "5167" => "loss of use of foot",
    "5170" => "amputation of toes",
    "5171" => "amputation of toes",
    "5172" => "amputation of toes",
    "5173" => "amputation of toes",
    "5199" => "amputation",
    "5200" => "ankylosis of shoulder",
    "5201" => "limitation of arm motion",
    "5202" => "impairment of upper arm",
    "5203" => "impairment of collar bone or shoulder blade",
    "5205" => "ankylosis of elbow",
    "5206" => "limitation of forearm motion (flexion)",
    "5207" => "limitation of forearm motion (extension)",
    "5208" => "limitation of forearm motion",
    "5209" => "impairment of elbow with flail joint",
    "5210" => "forearm nonunion with flail false joint",
    "5211" => "impairment of forearm",
    "5212" => "impairment of forearm",
    "5213" => "impairment of forearm",
    "5214" => "ankylosis of wrist",
    "5215" => "limitation of wrist motion",
    "5216" => "ankylosis of fingers",
    "5217" => "ankylosis of fingers",
    "5218" => "ankylosis of fingers",
    "5219" => "ankylosis of fingers",
    "5220" => "ankylosis of fingers",
    "5221" => "ankylosis of fingers",
    "5222" => "ankylosis of fingers",
    "5223" => "ankylosis of fingers",
    "5224" => "ankylosis of thumb",
    "5225" => "ankylosis of fingers",
    "5226" => "ankylosis of fingers",
    "5227" => "ankylosis of fingers",
    "5228" => "limitation of thumb motion",
    "5229" => "limitation of finger motion",
    "5230" => "limitation of finger motion",
    "5235" => "vertebral fracture or dislocation",
    "5236" => "sacroiliac injury and weakness",
    "5237" => "lumbosacral or cervical strain",
    "5238" => "spinal stenosis",
    "5239" => "spondylolisthesis or segmental instability",
    "5240" => "ankylosing spondylitis",
    "5241" => "spinal fusion",
    "5242" => "degenerative arthritis of the spine",
    "5243" => "intervertebral disc syndrome",
    "5250" => "ankylosis of hip",
    "5251" => "limitation of thigh motion (extension)",
    "5252" => "limitation of thigh motion (flexion)",
    "5253" => "limitation of thigh motion",
    "5254" => "impairment of hip",
    "5255" => "impairment of femur",
    "5256" => "ankylosis of knee",
    "5257" => "impairment of knee",
    "5258" => "dislocated knee cartilage",
    "5259" => "removal of knee cartilage",
    "5260" => "limitation of leg motion (flexion)",
    "5261" => "limitation of leg motion (extension)",
    "5262" => "impairment of lower leg",
    "5263" => "knee hyperextension",
    "5270" => "ankylosis of ankle",
    "5271" => "limitation of ankle motion",
    "5272" => "ankylosis of foot joints",
    "5273" => "malunion of foot bones",
    "5274" => "astragalectomy",
    "5275" => "shortening of lower extremity",
    "5276" => "flatfoot",
    "5277" => "weak feet",
    "5278" => "claw foot",
    "5279" => "metatarsalgia",
    "5280" => "bunion",
    "5281" => "hallux rigidus",
    "5282" => "hammer toe",
    "5283" => "malunion or nonunion of foot bones",
    "5284" => "foot injury",
    "5285" => "residuals of vertebral fracture",
    "5286" => "ankylosis of the spine",
    "5287" => "ankylosis of the spine",
    "5288" => "ankylosis of the spine",
    "5289" => "ankylosis of the spine",
    "5290" => "limitation of spinal motion",
    "5291" => "limitation of spinal motion",
    "5292" => "limitation of spinal motion",
    "5293" => "intervertebral disc syndrome",
    "5294" => "sacroiliac injury and weakness",
    "5295" => "lumbosacral strain",
    "5296" => "partial loss of skull",
    "5297" => "removal of ribs",
    "5298" => "removal of coccyx",
    "5299" => "skeletal injury or loss of motion",
    "5301" => "shoulder or arm muscle injury",
    "5302" => "shoulder or arm muscle injury",
    "5303" => "shoulder or arm muscle injury",
    "5304" => "shoulder or arm muscle injury",
    "5305" => "shoulder or arm muscle injury",
    "5306" => "shoulder or arm muscle injury",
    "5307" => "forearm or hand muscle injury",
    "5308" => "forearm or hand muscle injury",
    "5309" => "forearm or hand muscle injury",
    "5310" => "foot or leg muscle injury",
    "5311" => "foot or leg muscle injury",
    "5312" => "foot or leg muscle injury",
    "5313" => "pelvic or thigh muscle injury",
    "5314" => "pelvic or thigh muscle injury",
    "5315" => "pelvic or thigh muscle injury",
    "5316" => "pelvic or thigh muscle injury",
    "5317" => "pelvic or thigh muscle injury",
    "5318" => "pelvic or thigh muscle injury",
    "5319" => "torso or neck muscle injury",
    "5320" => "torso or neck muscle injury",
    "5321" => "torso or neck muscle injury",
    "5322" => "torso or neck muscle injury",
    "5323" => "torso or neck muscle injury",
    "5324" => "rupture of diaphragm",
    "5325" => "facial muscle injury",
    "5326" => "muscle hernia",
    "5327" => "malignant muscle neoplasm",
    "5328" => "benign muscle neoplasm",
    "5329" => "soft tissue sarcoma",
    "5399" => "muscle injury",
    "6000" => "uveitis",
    "6001" => "keratitis",
    "6002" => "scleritis",
    "6003" => "iritis",
    "6004" => "cyclitis",
    "6005" => "choroiditis",
    "6006" => "retinitis",
    "6007" => "intraocular hemorrhage",
    "6008" => "retinal detachment",
    "6009" => "eye injury",
    "6010" => "tuberculosis of the eye",
    "6011" => "retinal scarring or atrophy",
    "6012" => "glaucoma",
    "6013" => "glaucoma",
    "6014" => "malignant eye growth",
    "6015" => "benign eye growth",
    "6016" => "nystagmus",
    "6017" => "trachoma",
    "6018" => "chronic conjunctivitis",
    "6019" => "ptosis",
    "6020" => "ectropion",
    "6021" => "entropion",
    "6022" => "lagophthalmos",
    "6023" => "loss of eyebrows",
    "6024" => "loss of eyelashes",
    "6025" => "epiphora",
    "6026" => "optic neuritis",
    "6027" => "traumatic cataract",
    "6028" => "cataract",
    "6029" => "aphakia",
    "6030" => "paralysis of accommodation",
    "6031" => "dacryocystitis",
    "6032" => "partial loss of eyelids",
    "6033" => "crystalline lens dislocation",
    "6034" => "pterygium",
    "6035" => "keratoconus",
    "6061" => "loss of both eyes",
    "6062" => "blindness in both eyes",
    "6063" => "loss of one eye and blindness in other eye",
    "6064" => "loss of one eye and impairment of other eye",
    "6065" => "loss of one eye and impairment of other eye",
    "6066" => "loss of one eye",
    "6067" => "blindness in both eyes",
    "6068" => "blindness in one eye and impairment of other eye",
    "6069" => "blindness in one eye and impairment of other eye",
    "6070" => "blindness in one eye",
    "6071" => "blindness in both eyes",
    "6072" => "blindness in one eye and impairment of other eye",
    "6073" => "blindness in one eye and impairment of other eye",
    "6074" => "blindness in one eye",
    "6075" => "partial blindness in both eyes",
    "6076" => "partial blindness in one eye and impairment of other eye",
    "6077" => "partial blindness in one eye",
    "6078" => "partial blindness in both eyes",
    "6079" => "partial blindness in one eye",
    "6080" => "impairment of field vision",
    "6081" => "scotoma",
    "6090" => "double vision",
    "6091" => "symblepharon",
    "6092" => "double vision",
    "6099" => "eye disability",
    "6100" => "hearing loss",
    "6199" => "hearing loss",
    "6200" => "chronic suppurative otitis media, mastoiditis, or cholesteatoma",
    "6201" => "chronic otitis media with effusion",
    "6202" => "otosclerosis",
    "6204" => "inner ear or vestibular nerve disorder",
    "6205" => "Ménière's disease",
    "6207" => "loss or deformity of ear",
    "6208" => "malignant ear neoplasm",
    "6209" => "benign ear neoplasm",
    "6210" => "chronic otitis externa",
    "6211" => "perforation of tympanic membrane",
    "6260" => "tinnitus",
    "6275" => "loss of sense of smell",
    "6276" => "loss of sense of taste",
    "6299" => "sense organ disability",
    "6300" => "cholera",
    "6301" => "visceral leishmaniasis",
    "6302" => "Hansen's disease (leprosy)",
    "6304" => "malaria",
    "6305" => "lymphatic filariasis",
    "6306" => "bartonellosis",
    "6307" => "plague",
    "6308" => "relapsing fever",
    "6309" => "rheumatic fever",
    "6310" => "syphilis or other treponemal infection",
    "6311" => "miliary tuberculosis",
    "6313" => "avitaminosis",
    "6314" => "thiamine deficiency",
    "6315" => "pellagra",
    "6316" => "brucellosis",
    "6317" => "scrub typhus",
    "6318" => "melioidosis",
    "6319" => "Lyme disease",
    "6320" => "parasitic disease",
    "6350" => "lupus",
    "6351" => "HIV-related illness",
    "6354" => "chronic fatigue syndrome",
    "6399" => "infectious disease, immune disorder, or nutritional deficiency",
    "6502" => "deviated septum",
    "6504" => "partial loss or scarring of nose",
    "6510" => "chronic sinusitis",
    "6511" => "chronic sinusitis",
    "6512" => "chronic sinusitis",
    "6513" => "chronic sinusitis",
    "6514" => "chronic sinusitis",
    "6515" => "laryngeal tuberculosis",
    "6516" => "chronic laryngitis",
    "6518" => "laryngectomy",
    "6519" => "aphonia",
    "6520" => "laryngeal stenosis",
    "6521" => "throat injury",
    "6522" => "rhinitis",
    "6523" => "bacterial rhinitis",
    "6524" => "granulomatous rhinitis",
    "6599" => "nose or throat disease",
    "6600" => "chornic bronchitis",
    "6601" => "bronchiectasis",
    "6602" => "broncial asthma",
    "6603" => "emphysema",
    "6604" => "chronic obstructive pulmonary disease",
    "6699" => "tracheal or bronchial disease",
    "6701" => "pulmonary tuberculosis",
    "6702" => "pulmonary tuberculosis",
    "6703" => "pulmonary tuberculosis",
    "6704" => "pulmonary tuberculosis",
    "6721" => "pulmonary tuberculosis",
    "6722" => "pulmonary tuberculosis",
    "6723" => "pulmonary tuberculosis",
    "6724" => "pulmonary tuberculosis",
    "6730" => "pulmonary tuberculosis",
    "6731" => "pulmonary tuberculosis",
    "6732" => "tuberculous pleurisy",
    "6799" => "tuberculous disease",
    "6817" => "pulmonary vascular disease",
    "6819" => "malignant neoplasm of the respiratory system",
    "6820" => "benign neoplasm of the respiratory system",
    "6822" => "actinomycosis",
    "6823" => "nocardiosis",
    "6824" => "chronic lung abscess",
    "6825" => "diffuse interstitial fibrosis",
    "6826" => "desquamative interstitial pneumonitis",
    "6827" => "pulmonary alveolar proteinosis",
    "6828" => "eosinophilic granuloma",
    "6829" => "drug-induced pneumonitis or fibrosis",
    "6830" => "radiation-induced pneumonitis or fibrosis",
    "6831" => "hypersensitivity pneumonitis",
    "6832" => "pneumoconiosis",
    "6833" => "asbestosis",
    "6834" => "histoplasmosis",
    "6835" => "coccidioidomycosis",
    "6836" => "blastomycosis",
    "6837" => "cryptococcosis",
    "6838" => "aspergillosis",
    "6839" => "mucormycosis",
    "6840" => "diaphragm paralysis or paresis",
    "6841" => "spinal cord injury affecting the respiratory system",
    "6842" => "kyphoscoliosis, pectus excavatum, or pectus carinatum",
    "6843" => "collapsed lung, hernia, or other traumatic chest wall defect",
    "6844" => "lung surgery",
    "6845" => "chronic pleural effusion or fibrosis",
    "6846" => "sarcoidosis",
    "6847" => "sleep apnea",
    "6899" => "lung disease",
    "7000" => "heart valve disease",
    "7001" => "endocarditis",
    "7002" => "pericarditis",
    "7003" => "pericardial adhesions",
    "7004" => "syphilitic heart disease",
    "7005" => "coronary artery disease",
    "7006" => "myocardial infarction",
    "7007" => "hypertensive heart disease",
    "7008" => "hyperthyroid heart disease",
    "7010" => "supraventricular arrhythmias",
    "7011" => "ventricular arrhythmias",
    "7015" => "atrioventricular block",
    "7016" => "heart valve replacement",
    "7017" => "coronary bypass surgery",
    "7018" => "pacemaker",
    "7019" => "heart transplant",
    "7020" => "cardiomyopathy",
    "7099" => "heart disease",
    "7101" => "hypertensive vascular disease",
    "7110" => "aortic aneurysm",
    "7111" => "arterial aneurysm",
    "7112" => "arterial aneurysm",
    "7113" => "arteriovenous fistula",
    "7114" => "arteriosclerosis obliterans",
    "7115" => "Buerger's disease",
    "7117" => "Raynaud's disease",
    "7118" => "angioedema",
    "7119" => "erythromelalgia",
    "7120" => "varicose veins",
    "7121" => "post-thrombotic syndrome",
    "7122" => "cold injury",
    "7123" => "soft tissue sarcoma",
    "7199" => "arterial or venous disease",
    "7200" => "mouth injury",
    "7201" => "lips injury",
    "7202" => "whole or partial loss of tongue",
    "7203" => "esophageal stricture",
    "7204" => "esophageal spasm",
    "7205" => "esophageal diverticulum",
    "7299" => "digestive system injury",
    "7301" => "peritoneal adhesions",
    "7304" => "ulcer",
    "7305" => "ulcer",
    "7306" => "ulcer",
    "7307" => "giant hypertrophic gastritis",
    "7308" => "postgastrectomy syndromes",
    "7309" => "stomach stenosis",
    "7310" => "stomach injury",
    "7311" => "liver injury",
    "7312" => "cirrhosis",
    "7313" => "liver abscess",
    "7314" => "chronic cholecystitis",
    "7315" => "chronic cholelithiasis",
    "7316" => "chronic cholangitis",
    "7317" => "gallbladder injury",
    "7318" => "gallbladder removal",
    "7319" => "irritable bowel syndrome",
    "7321" => "amebiasis",
    "7322" => "bacillary dysentery",
    "7323" => "ulcerative colitis",
    "7324" => "distomiasis",
    "7325" => "chronic enteritis",
    "7326" => "chronic enterocolitis",
    "7327" => "diverticulitis",
    "7328" => "bowel resection",
    "7329" => "bowel resection",
    "7330" => "intestinal fistula",
    "7331" => "peritoneal tuberculosis",
    "7332" => "impairment of sphincter control",
    "7333" => "anal stricture",
    "7334" => "prolapsed rectum",
    "7335" => "anal fistula",
    "7336" => "hemorrhoids",
    "7337" => "pruritus ani",
    "7338" => "groin hernia",
    "7339" => "ventral hernia",
    "7340" => "femoral hernia",
    "7342" => "visceroptosis",
    "7343" => "malignant digestive neoplasm",
    "7344" => "benign digestive neoplasm",
    "7345" => "chronic liver disease",
    "7346" => "stomach hernia",
    "7347" => "pancreatitis",
    "7348" => "vagotomy",
    "7351" => "liver transplant",
    "7354" => "hepatitis C",
    "7399" => "digestive system disease",
    "7500" => "removal of kidney",
    "7501" => "kidney abscess",
    "7502" => "chronic nephritis",
    "7504" => "chronic pyelonephritis",
    "7505" => "tuberculosis of the kidney",
    "7507" => "arteriolar nephrosclerosis",
    "7508" => "nephrolithiasis",
    "7509" => "hydronephrosis",
    "7510" => "ureterolithiasis",
    "7511" => "ureter stricture",
    "7512" => "chornic cystitis",
    "7515" => "bladder stone",
    "7516" => "bladder fistula",
    "7517" => "bladder injury",
    "7518" => "ureteral stricture",
    "7519" => "ureteral fistula",
    "7520" => "removal of penis",
    "7521" => "removal of glans",
    "7522" => "penile deformity",
    "7523" => "testicular atrophy",
    "7524" => "removal of testis",
    "7525" => "chronic epididymo-orchitis",
    "7527" => "prostate gland injury",
    "7528" => "malignant genital or urinary neoplasm",
    "7529" => "benign genital or urinary neoplasm",
    "7530" => "chronic renal disease",
    "7531" => "kidney transplant",
    "7532" => "renal tubular disorder",
    "7533" => "cystic kidney disease",
    "7534" => "atherosclerotic renal disease",
    "7535" => "toxic nephropathy",
    "7536" => "glomerulonephritis",
    "7537" => "interstitial nephritis",
    "7538" => "papillary necrosis",
    "7539" => "renal amyloid disease",
    "7540" => "renal cortical necrosis",
    "7541" => "renal manifestation of systemic disease",
    "7542" => "neurogenic bladder",
    "7599" => "genital or urinary disability",
    "7610" => "vulval disease or injury",
    "7611" => "vaginal disease or injury",
    "7612" => "cervical disease or injury",
    "7613" => "uterine disease, injury, or adhesions",
    "7614" => "fallopian tube disease, injury, or adhesions",
    "7615" => "ovarian disease, injury, or adhesions",
    "7617" => "removal of uterus and both ovaries",
    "7618" => "removal of uterus",
    "7619" => "removal of ovary",
    "7620" => "ovarian atrophy",
    "7621" => "prolapsed uterus",
    "7622" => "displaced uterus",
    "7623" => "surgical complications of pregnancy",
    "7624" => "rectovaginal fistula",
    "7625" => "urethrovaginal fistula",
    "7626" => "breast surgery",
    "7627" => "malignant gynecological or breast neoplasm",
    "7628" => "benign gynecological or breast neoplasm",
    "7629" => "endometriosis",
    "7699" => "gynecological or breast disability",
    "7700" => "microcytic or megaloblastic anemia",
    "7702" => "agranulocytosis",
    "7703" => "leukemia",
    "7704" => "polycythemia vera",
    "7705" => "thrombocytopenia",
    "7706" => "splenectomy",
    "7707" => "spleen injury",
    "7709" => "Hodgkin's disease",
    "7710" => "tuberculous lymphadenitis",
    "7714" => "sickle cell anemia",
    "7715" => "non-Hodgkin's lymphoma",
    "7716" => "aplastic anemia",
    "7799" => "hemic or lymphatic disability",
    "7800" => "disfigurement of head, face, or neck",
    "7801" => "scarring",
    "7802" => "scarring",
    "7803" => "scarring",
    "7804" => "scarring",
    "7805" => "scarring",
    "7806" => "eczema",
    "7807" => "leishmaniasis",
    "7808" => "leishmaniasis",
    "7809" => "cutaneous lupus erythematosus",
    "7810" => "pinta",
    "7811" => "tuberculosis luposa",
    "7812" => "verruga peruana",
    "7813" => "ringworm",
    "7814" => "tinea barbae",
    "7815" => "bullous disease",
    "7816" => "psoriasis",
    "7817" => "exfoliative dermatitis",
    "7818" => "malignant skin neoplasm",
    "7819" => "benign skin neoplasm",
    "7820" => "skin infection",
    "7821" => "cutaneous manifestation of collagen-vascular disease",
    "7822" => "papulosquamous disorder",
    "7823" => "vitiligo",
    "7824" => "keratinization disease",
    "7825" => "hives",
    "7826" => "vasculitis",
    "7827" => "erythema multiforme or toxic epidermal necrolysis",
    "7828" => "acne",
    "7829" => "chloracne",
    "7830" => "scarring alopecia",
    "7831" => "alopecia areata",
    "7832" => "hyperhidrosis",
    "7833" => "malignant melanoma",
    "7899" => "skin disability",
    "7900" => "hyperthyroidism",
    "7901" => "thyroid adenoma",
    "7902" => "thyroid adenoma",
    "7903" => "hypothyroidism",
    "7904" => "hyperparathyroidism",
    "7905" => "hypoparathyroidism",
    "7907" => "Cushing's syndrome",
    "7908" => "acromegaly",
    "7909" => "diabetes insipidus",
    "7911" => "Addison's disease",
    "7912" => "pluriglandular syndrome",
    "7913" => "diabetes",
    "7914" => "malignant endocrine neoplasm",
    "7915" => "benign endocrine neoplasm",
    "7916" => "hyperpituitarism",
    "7917" => "hyperaldosteronism",
    "7918" => "pheochromocytoma",
    "7919" => "C-cell hyperplasia",
    "7999" => "endocrine system disability",
    "8000" => "chronic epidemic encephalitis",
    "8002" => "malignant brain growth",
    "8003" => "benign brain growth",
    "8004" => "Parkinson's disease",
    "8005" => "bulbar palsy",
    "8007" => "brain aneurysm",
    "8008" => "cerebral venous sinus thrombosis",
    "8009" => "hemorrhagic stroke",
    "8010" => "myelitis",
    "8011" => "polio",
    "8012" => "hematomyelia",
    "8013" => "neurosyphilis",
    "8014" => "meningovascular syphilis",
    "8015" => "tabes dorsalis",
    "8017" => "amyotrophic lateral sclerosis",
    "8018" => "multiple sclerosis",
    "8019" => "epidemic cerebrospinal meningitis",
    "8020" => "brain abscess",
    "8021" => "malignant spinal cord growth",
    "8022" => "benign spinal cord growth",
    "8023" => "progressive muscular atrophy",
    "8024" => "syringomyelia",
    "8025" => "myasthenia gravis",
    "8045" => "brain disease due to trauma",
    "8046" => "cerebral arteriosclerosis",
    "8099" => "central nervous system disease",
    "8100" => "migraines",
    "8103" => "convulsive tic",
    "8104" => "paramyoclonus multiplex",
    "8105" => "Sydenham's chorea",
    "8106" => "Huntington's disease",
    "8107" => "athetosis",
    "8108" => "narcolepsy",
    "8199" => "neurological disease",
    "8205" => "trigeminal nerve paralysis",
    "8207" => "facial nerve paralysis",
    "8209" => "glossopharyngeal nerve paralysis",
    "8210" => "vagus nerve paralysis",
    "8211" => "accessory nerve paralysis",
    "8212" => "hypoglossal nerve paralysis",
    "8299" => "cranial nerve paralysis",
    "8305" => "trigeminal nerve neuritis",
    "8307" => "facial nerve neuritis",
    "8309" => "glossopharyngeal nerve neuritis",
    "8310" => "vagus nerve neuritis",
    "8311" => "accessory nerve neuritis",
    "8312" => "hypoglossal nerve neuritis",
    "8399" => "cranial nerve neuritis",
    "8405" => "trigeminal nerve neuralgia",
    "8407" => "facial nerve neuralgia",
    "8409" => "glossopharyngeal nerve neuralgia",
    "8410" => "vagus nerve neuralgia",
    "8411" => "accessory nerve neuralgia",
    "8412" => "hypoglossal nerve neuralgia",
    "8499" => "cranial nerve neuralgia",
    "8510" => "paralysis of upper radicular group",
    "8511" => "paralysis of middle radicular group",
    "8512" => "paralysis of lower radicular group",
    "8513" => "paralysis of all radicular groups",
    "8514" => "musculospiral nerve paralysis",
    "8515" => "median nerve paralysis",
    "8516" => "ulnar nerve paralysis",
    "8517" => "musculocutaneous nerve paralysis",
    "8518" => "circumflex nerve paralysis",
    "8519" => "long thoracic nerve paralysis",
    "8520" => "sciatic nerve paralysis",
    "8521" => "external popliteal nerve paralysis",
    "8522" => "musculocutaneous nerve paralysis",
    "8523" => "anterior tibial nerve paralysis",
    "8524" => "internal popliteal nerve paralysis",
    "8525" => "posterior tibial nerve paralysis",
    "8526" => "anterior crural nerve paralysis",
    "8527" => "internal saphenous nerve paralysis",
    "8528" => "obturator nerve paralysis",
    "8529" => "external cutaneous nerve of thigh paralysis",
    "8530" => "ilioinguinal nerve paralysis",
    "8540" => "soft-tissue sarcoma",
    "8599" => "peripheral nerve paralysis",
    "8610" => "neuritis of upper radicular group",
    "8611" => "neuritis of middle radicular group",
    "8612" => "neuritis of lower radicular group",
    "8613" => "neuritis of all radicular groups",
    "8614" => "musculospiral nerve neuritis",
    "8615" => "median nerve neuritis",
    "8616" => "ulnar nerve neuritis",
    "8617" => "musculocutaneous nerve neuritis",
    "8618" => "circumflex nerve neuritis",
    "8619" => "long thoracic nerve neuritis",
    "8620" => "sciatic nerve neuritis",
    "8621" => "external popliteal nerve neuritis",
    "8622" => "musculocutaneous nerve neuritis",
    "8623" => "anterior tibial nerve neuritis",
    "8624" => "internal popliteal nerve neuritis",
    "8625" => "posterior tibial nerve neuritis",
    "8626" => "anterior crural nerve neuritis",
    "8627" => "internal saphenous nerve neuritis",
    "8628" => "obturator nerve neuritis",
    "8629" => "external cutaneous nerve of thigh neuritis",
    "8630" => "ilioinguinal nerve neuritis",
    "8699" => "peripheral nerve neuritis",
    "8710" => "neuralgia of upper radicular group",
    "8711" => "neuralgia of middle radicular group",
    "8712" => "neuralgia of lower radicular group",
    "8713" => "neuralgia of all radicular groups",
    "8714" => "musculospiral nerve neuralgia",
    "8715" => "median nerve neuralgia",
    "8716" => "ulnar nerve neuralgia",
    "8717" => "musculocutaneous nerve neuralgia",
    "8718" => "circumflex nerve neuralgia",
    "8719" => "long thoracic nerve neuralgia",
    "8720" => "sciatic nerve neuralgia",
    "8721" => "external popliteal nerve neuralgia",
    "8722" => "musculocutaneous nerve neuralgia",
    "8723" => "anterior tibial nerve neuralgia",
    "8724" => "internal popliteal nerve neuralgia",
    "8725" => "posterior tibial nerve neuralgia",
    "8726" => "anterior crural nerve neuralgia",
    "8727" => "internal saphenous nerve neuralgia",
    "8728" => "obturator nerve neuralgia",
    "8729" => "external cutaneous nerve of thigh neuralgia",
    "8730" => "ilioinguinal nerve neuralgia",
    "8799" => "peripheral nerve neuralgia",
    "8850" => "undiagnosed condition related to musculoskeletal disease",
    "8851" => "undiagnosed condition related to amputation",
    "8852" => "undiagnosed joints, skull, or ribs condition",
    "8853" => "undiagnosed condition related to muscle injuries",
    "8860" => "undiagnosed condition related to diseases of the eye",
    "8861" => "undiagnosed condition related to hearing loss",
    "8862" => "undiagnosed ear or other sense organ condition",
    "8863" => "undiagnosed condition related to systemic disease",
    "8865" => "undiagnosed nose or throat condition",
    "8866" => "undiagnosed tracheal or broncheal condition",
    "8867" => "undiagnosed condition related to tuberculosis",
    "8868" => "undiagnosed lung condition",
    "8870" => "undiagnosed condition related to heart disease",
    "8871" => "undiagnosed arterial or venous condition",
    "8872" => "undiagnosed digestive condition",
    "8873" => "undiagnosed digestive condition",
    "8875" => "undiagnosed genital or urniary condition",
    "8876" => "undiagnosed gynecological condition",
    "8877" => "undiagnosed hemic or lymphatic condition",
    "8878" => "undiagnosed skin condition",
    "8879" => "undiagnosed endocrine condition",
    "8880" => "undiagnosed condition of the central nervous system",
    "8881" => "undiagnosed neurological condition",
    "8882" => "undiagnosed condition related to cranial nerve paralysis",
    "8883" => "undiagnosed condition related to cranial nerve neuritis",
    "8884" => "undiagnosed condition related to cranial nerve neuralgia",
    "8885" => "undiagnosed condition related to peripheral nerve paralysis",
    "8886" => "undiagnosed condition related to peripheral nerve neuritis",
    "8887" => "undiagnosed condition related to peripheral nerve neuralgia",
    "8889" => "undiagnosed epileptic condition",
    "8892" => "undiagnosed psychotic condition",
    "8893" => "undiagnosed organic mental condition",
    "8894" => "undiagnosed psychonerotic condition",
    "8895" => "undiagnosed psychophysiologic condition",
    "8899" => "undiagnosed dental or oral condition",
    "8910" => "epilepsy",
    "8911" => "epilepsy",
    "8912" => "epilepsy",
    "8913" => "epilepsy",
    "8914" => "epilepsy",
    "8999" => "epilepsy",
    "9201" => "schizophrenia",
    "9202" => "schizophrenia",
    "9203" => "schizophrenia",
    "9204" => "schizophrenia",
    "9205" => "schizophrenia",
    "9208" => "delusional disorder",
    "9210" => "psychotic disorder",
    "9211" => "schizoaffective disorder",
    "9299" => "psychotic disorder",
    "9300" => "delirium",
    "9301" => "dementia",
    "9304" => "dementia",
    "9305" => "vascular dementia",
    "9310" => "dementia",
    "9312" => "Alzheimer's disease",
    "9326" => "dementia",
    "9327" => "organic mental disorder",
    "9400" => "generalized anxiety disorder",
    "9403" => "specific phobia",
    "9404" => "obsessive compulsive disorder",
    "9410" => "neurosis",
    "9411" => "post-traumatic stress disorder",
    "9412" => "panic disorder or agoraphobia",
    "9413" => "anxiety disorder",
    "9416" => "dissociative disorder",
    "9417" => "depersonalization disorder",
    "9421" => "somatization disorder",
    "9422" => "pain disorder",
    "9423" => "undifferentiated somatoform disorder",
    "9424" => "conversion disorder",
    "9425" => "hypochondriasis",
    "9431" => "cyclothymic disorder",
    "9432" => "bipolar disorder",
    "9433" => "dysthymic disorder",
    "9434" => "major depressive disorder",
    "9435" => "mood disorder",
    "9440" => "chronic adjustment disorder",
    "9499" => "nonpsychotic emotional illness",
    "9520" => "anorexia",
    "9521" => "bulimia",
    "9599" => "eating disorder",
    "9900" => "chronic osteomyelitis or osteoradionecrosis of jaws",
    "9901" => "loss of lower jaw",
    "9902" => "partial loss of lower jaw",
    "9903" => "nonunion of lower jaw",
    "9904" => "malunion of lower jaw",
    "9905" => "limitation of jaw motion",
    "9906" => "partial loss of lower jaw",
    "9907" => "partial loss of lower jaw",
    "9908" => "partial loss of lower jaw",
    "9909" => "partial loss of lower jaw",
    "9911" => "loss of hard palate",
    "9912" => "partial loss of hard palate",
    "9913" => "tooth loss",
    "9914" => "loss of upper jaw",
    "9915" => "partial loss of upper jaw",
    "9916" => "malunion or nonunion of upper jaw",
    "9999" => "dental or oral condition"
  }.freeze

  # rubocop:disable Style/FormatStringToken
  ISSUE_DESCRIPTIONS = {
    "01" => "Burial benefits",
    "02" => {
      "01" => {
        "01" => "Benefits as a result of VA error (Section 1151)",
        "02" => "Benefits as a result of VA error (Section 1151)"
      },
      "02" => "Apportionment",
      "03" => {
        "01" => "Eligibility for adaptive equipment",
        "02" => "Adaptive equipment"
      },
      "04" => {
        "01" => "Eligibility for Civil Service preference"
      },
      "05" => {
        "01" => "Eligibility for clothing allowance",
        "02" => "Clothing allowance",
        "03" => "Timeliness of filing for clothing allowance"
      },
      "06" => "Competence to manage own finances",
      "07" => {
        "01" => "Clear and unmistakable error, accrued benefits",
        "02" => "Clear and unmistakable error, survivor benefits",
        "03" => "Clear and unmistakable error, effective date",
        "04" => "Clear and unmistakable error, rating",
        "05" => "Clear and unmistakable error, service connection",
        "06" => "Clear and unmistakable error, 100% rating for individual unemployability",
        "07" => "Clear and unmistakable error, 100% rating for temporary total disability",
        "08" => "Clear and unmistakable error"
      },
      "08" => {
        "01" => "Benefits for survivors of Veterans with total disability",
        "02" => "Survivor benefits",
        "03" => "Service-connected cause of death",
        "04" => "Status as claimant of survivor benefits",
        "05" => "Survivor benefits"
      },
      "09" => {
        "01" => "Effective date, accrued benefits",
        "02" => "Effective date, survivor benefits",
        "03" => "Effective date, rating",
        "04" => "Effective date, service connection",
        "05" => "Effective date, 100% rating for individual unemployability",
        "06" => "Effective date, 100% rating for temporary total disability",
        "07" => "Effective date"
      },
      "10" => "Forfeiture of benefits",
      "11" => {
        "01" => "Increased rate for dependents",
        "02" => "Increased rate for adoption of dependent",
        "03" => "Increased rate for helpless child",
        "04" => "Paternity",
        "05" => "Increased rate for stepchild",
        "06" => "Validity of marriage for VA purposes",
        "07" => "Increased rate for dependents"
      },
      "12" => {
        "01" => "10% rating for multiple noncompensable disabilities",
        "02" => "Increased rating, %s",
        "03" => "Increased rating, %s",
        "04" => "Increased rating, %s",
        "05" => "Increased rating, special monthly compensation",
        "06" => "100% rating for temporary total disability",
        "07" => "Increased rating",
        "08" => "Increased rating, %s"
      },
      "13" => {
        "01" => "Validity of debt owed",
        "02" => "Waiver of indebtedness"
      },
      "14" => {
        "01" => "Severance of service connection, %s",
        "02" => "Severance of service connection, dental",
        "03" => "Severance of service connection, %s"
      },
      "15" => {
        "01" => "Service connection, %s",
        "02" => "Service connection, dental",
        "03" => "Service connection, %s",
        "04" => "New and material evidence to reopen claim for service connection, %s"
      },
      "16" => {
        "01" => "Character of discharge for VA purposes",
        "02" => "Recognized service",
        "03" => "Status as a Veteran"
      },
      "17" => {
        "01" => "100% rating for individual unemployability",
        "02" => "100% rating for individual unemployability",
        "03" => "Rating reduction, 100% rating for individual unemployability"
      },
      "18" => {
        "01" => {
          "01" => "Rating reduction, %s",
          "02" => "Rating reduction, %s",
          "03" => "Protection of rating",
          "04" => "Rating reduction, %s",
          "05" => "Rating reduction, special monthly compensation",
          "06" => "Rating reduction, 100% rating for temporary total disability",
          "07" => "Rating reduction"
        },
        "02" => {
          "01" => "Reduction in compensation, incarceration",
          "02" => "Reduction in compensation, institutionalization",
          "03" => "Reduction in compensation, removal of dependent",
          "04" => "Reduction in compensation, recoupment",
          "05" => "Reduction in compensation"
        }
      },
      "19" => {
        "01" => "Eligibility for specially adapted housing",
        "02" => "Specially adapted housing"
      },
      "20" => {
        "01" => "Educational assistance for survivors",
        "02" => "Eligibility for educational assistance for survivors and dependents",
        "03" => "Educational assistance for survivors and dependents"
      },
      "21" => "Willful misconduct",
      "22" => "Eligibility for substitution"
    },
    "03" => {
      "01" => "Education benefits",
      "02" => {
        "01" => "Eligibility for Montgomery GI Bill, Active Duty",
        "02" => "Eligibility for Dependents' Educational Assistance",
        "03" => "Eligibility for Veterans Education Assistance Program",
        "04" => "Eligibility for Educational Assistance Test Program"
      },
      "03" => {
        "01" => "Effective date, Montgomery GI Bill, Active Duty",
        "02" => "Effective date, Montgomery GI Bill, Selected Reserve",
        "03" => "Effective date, Dependents' Educational Assistance",
        "04" => "Effective date, Veterans Education Assistance Program",
        "05" => "Effective date, Educational Assistance Test Program"
      },
      "04" => {
        "01" => "Extension of delimiting date, Montgomery GI Bill, Active Duty",
        "02" => "Extension of delimiting date, Montgomery GI Bill, Selected Reserve",
        "03" => "Extension of delimiting date, Dependents' Educational Assistance",
        "04" => "Extension of delimiting date, Veterans Education Assistance Program"
      },
      "05" => {
        "01" => "Validity of debt owed",
        "02" => "Waiver of indebtedness"
      },
      "06" => "Education benefits"
    },
    "04" => "Insurance benefits",
    "05" => {
      "01" => "Eligibility for loan guaranty benefits",
      "02" => "Validity of debt owed",
      "03" => "Waiver of indebtedness",
      "04" => "Retroactive release of liability",
      "05" => "Restoration of entitlement",
      "06" => "Loan guaranty benefits"
    },
    "06" => "Medical benefits",
    "07" => {
      "01" => "Pension benefits",
      "02" => "Apportionment",
      "03" => "Countable income",
      "04" => "Clear and unmistakable error, pension benefits",
      "05" => "Survivors pension benefits",
      "06" => "Effective date, pension benefits",
      "07" => {
        "01" => "Eligibility for pension, wartime service",
        "02" => "Eligibility for pension, unemployability",
        "03" => "Eligibility for pension, recognized service"
      },
      "08" => {
        "01" => "Increased rate for adoption of dependent",
        "02" => "Increased rate for helpless child",
        "03" => "Paternity",
        "04" => "Increased rate for stepchild",
        "05" => "Validity of marriage for VA purposes",
        "06" => "Increased rate for dependents"
      },
      "09" => "Special monthly pension",
      "10" => {
        "01" => "Validity of debt owed",
        "02" => "Waiver of indebtedness"
      },
      "11" => "Willful misconduct",
      "12" => "Pension benefits"
    },
    "08" => "Vocational Rehabilitation and Employment benefits",
    "09" => {
      "01" => {
        "01" => "Failure to withhold attorney fees",
        "02" => "Eligibility for attorney fees",
        "03" => "Reasonableness of attorney fees"
      },
      "02" => {
        "01" => "Eligibility for Restored Entitlement Program for Survivors",
        "02" => "Relationship to Veteran",
        "03" => "Full-time school attendance",
        "04" => "Income or self-employment",
        "05" => {
          "01" => "Validity of debt owed",
          "02" => "Waiver of indebtedness"
        }
      },
      "03" => {
        "01" => "Effective date, spina bifida",
        "02" => "Eligibility for spina bifida",
        "03" => "Level of disability",
        "04" => "Spina bifida"
      },
      "04" => "Waiver of VA employee indebtedness",
      "05" => "Certifications with respect to circumstances of death",
      "06" => "Accreditation",
      "07" => "VBMS Access"
    },
    "10" => {
      "01" => {
        "01" => "Payment from past-due benefits",
        "02" => "Reasonableness of attorney fees"
      },
      "02" => {
        "01" => "Clear and unmistakable error, compensation",
        "02" => "Clear and unmistakable error, pension",
        "03" => "Clear and unmistakable error"
      },
      "03" => {
        "01" => "Rule 608 motion to withdraw",
        "02" => "Rule 702, 704, or 717 motion for new hearing date",
        "03" => "Rule 711 motion to issue or quash subpoena",
        "04" => "Rule 716 motion for correction of hearing transcript",
        "05" => "Rule 900 motion to advance on docket",
        "06" => "Rule 904 motion to vacate",
        "07" => "Rule 1001 motion for reconsideration",
        "08" => {
          "01" => "Rule 1304(b) motion to submit additional evidence",
          "02" => "Rule 1304(b) motion to request personal hearing",
          "03" => "Rule 1304(b) motion to change representative"
        }
      },
      "04" => "Designation of record"
    },
    "11" => "Burial benefits",
    "12" => {
      "01" => "Fiduciary appointment"
    }
  }.freeze
  # rubocop:enable Style/FormatStringToken

  PROGRAMS = {
    "01" => :vba_burial,
    "02" => :compensation,
    "03" => :education,
    "04" => :insurance,
    "05" => :loan_guaranty,
    "06" => :medical,
    "07" => :pension,
    "08" => :vre,
    "09" => :other,
    "10" => :bva,
    "11" => :nca_burial,
    "12" => :fiduciary
  }.freeze

  def program
    PROGRAMS[codes[0]]
  end

  def aoj
    AOJ_FOR_PROGRAMS.keys.find do |type|
      AOJ_FOR_PROGRAMS[type].include?(program)
    end
  end

  def type
    labels[1]
  end

  def program_description
    "#{codes[0]} - #{labels[0]}"
  end

  def description
    codes[1..-1].zip(labels[1..-1]).map { |code, label| "#{code} - #{label}" }
  end

  def levels
    labels[2..-1] || []
  end

  def levels_with_codes
    codes[2..-1].zip(labels[2..-1]).map { |code, label| "#{code} - #{label}" }
  end

  def formatted_program_type_levels
    [
      [
        program.try(:capitalize),
        type
      ].compact.join(": ")
        .gsub(/Compensation/i, "Comp")
        .gsub(/Service Connection/i, "SC")
        .gsub(/Increased Rating/i, "IR"),
      levels_with_codes.join("; ")
    ].compact.join("\n")
  end

  def friendly_description
    friendly_description_for_codes(codes)
  end

  def friendly_description_without_new_material
    new_material? ? friendly_description_for_codes(%w[02 15 03]) : friendly_description
  end

  # returns "Remanded \n mm/dd/yyyy"
  def formatted_disposition
    [readable_disposition, close_date.try(:to_formatted_s, :short_date)].join("\n") if readable_disposition
  end

  def diagnostic_code
    codes.last if codes.last.length == 4
  end

  def category
    "#{codes[0]}-#{codes[1]}"
  end

  def type_hash
    codes.hash
  end

  def active?
    !disposition
  end

  def allowed?
    disposition == :allowed
  end

  def remanded?
    disposition == :remanded
  end

  def merged?
    disposition == :merged
  end

  # "New Material" (and "Non new material") are the exact
  # terms used internally by attorneys/judges. These mean the issue
  # was allowing/denying new material (such as medical evidence) to be used
  # in the appeal
  def new_material?
    codes[0..2] == %w[02 15 04]
  end

  def non_new_material?
    !new_material?
  end

  def non_new_material_allowed?
    non_new_material? && allowed?
  end

  def attributes
    {
      vacols_sequence_id: vacols_sequence_id,
      levels: levels,
      program: program,
      type: type,
      description: description,
      disposition: disposition,
      close_date: close_date,
      program_description: program_description,
      note: note
    }
  end

  def description_attributes
    {
      program_description: program_description,
      description: description,
      note: note
    }
  end

  private

  def friendly_description_for_codes(code_array)
    issue_description = code_array.reduce(ISSUE_DESCRIPTIONS) do |descriptions, code|
      descriptions = descriptions[code]
      # If there is no value, we probably haven't added the issue type in our list, so return.
      return nil unless descriptions
      break descriptions if descriptions.is_a?(String)
      descriptions
    end

    if diagnostic_code
      diagnostic_code_description = DIAGNOSTIC_CODE_DESCRIPTIONS[diagnostic_code]
      return if diagnostic_code_description.nil?
      # Some description strings are templates. This is a no-op unless the description string contains %s.
      issue_description = issue_description % diagnostic_code_description
    end

    issue_description
  end

  class << self
    attr_writer :repository

    def repository
      @repository ||= IssueRepository
    end

    def load_from_vacols(hash)
      disposition = nil
      if hash["issdc"]
        disposition = Constants::VACOLS_DISPOSITIONS_BY_ID[hash["issdc"]].parameterize.underscore.to_sym
      end
      new(
        id: hash["isskey"],
        vacols_sequence_id: hash["issseq"],
        codes: parse_codes_from_vacols(hash),
        labels: hash.key?("issprog_label") ? parse_labels_from_vacols(hash) : :not_loaded,
        note: hash["issdesc"],
        # disposition is a snake_case symbol, i.e. :remanded
        disposition: disposition,
        # readable disposition is a string, i.e. "Remanded"
        readable_disposition: Constants::VACOLS_DISPOSITIONS_BY_ID[hash["issdc"]],
        close_date: AppealRepository.normalize_vacols_date(hash["issdcls"])
      )
    end

    def create_in_vacols!(issue_attrs:)
      repository.create_vacols_issue!(issue_attrs: issue_attrs)
    end

    def update_in_vacols!(vacols_id:, vacols_sequence_id:, issue_attrs:)
      repository.update_vacols_issue!(
        vacols_id: vacols_id,
        vacols_sequence_id: vacols_sequence_id,
        issue_attrs: issue_attrs
      )
    end

    def delete_in_vacols!(vacols_id:, vacols_sequence_id:)
      repository.delete_vacols_issue!(
        vacols_id: vacols_id,
        vacols_sequence_id: vacols_sequence_id
      )
    end

    private

    def parse_codes_from_vacols(hash)
      [
        hash["issprog"],
        hash["isscode"],
        hash["isslev1"],
        hash["isslev2"],
        hash["isslev3"]
      ].compact
    end

    def parse_labels_from_vacols(hash)
      [
        hash["issprog_label"],
        hash["isscode_label"],
        hash["isslev1_label"],
        hash["isslev2_label"],
        hash["isslev3_label"]
      ].compact
    end
  end
end
# rubocop:enable Metrics/ClassLength
