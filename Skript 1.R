#DATEN EINLESEN + SEPARIEREN 
`ALL-Bcell_list` <- readRDS("E:/Studium/4. FS/Bioinfo05/project-05-group-01/ALL-Bcell_list.RDS") #Auslesen der Liste mit den Methylierungsdaten �ber Dateipfad (hier der auf meinem PC)
View(`ALL-Bcell_list`) # Tabelle in R-Studio anzeigen lassen
View(`ALL-Bcell_list`[["promoters"]]) # Nur die Tabelle der Promoter-daten anzeigen lassen
View(`ALL-Bcell_list`[["promoters"]][["Chromosome"]]) # Nur die Spalte "Chromosome" angezeigt
`ALL-Bcell_list`[["promoters"]] # Tabelle in Console angezeigt (da viele Daten nicht empfehlenswert)

# Ich pers�nlich habe die Datei der Liste in ALLBcell umbenannt im Dateinverzeichnis weil k�rzer und einfacher

colnames(ALLBcell[["promoters"]]) # Anzeigen aller Spaltenbezeichnungen der Liste "Promoters"
rownames(ALLBcell[["promoters"]]) # Anzeigen aller Zeilenbezeichnungen der Liste "Promoters"
dim(ALLBcell) # Anzeige der Dimensionen der Datenmatrix

ALLBcell[["promoters"]] -> ALLpromotor # Zusammenfassen einzig der Promoterdaten der Gesamtdatei unter einer Matrix "ALLpromotor", damit man nicht jedes Mal den Pfad �ber ALLBcell[["promoters"]] angeben muss

# ANZEIGEN BESTIMMTER INHALTE
ALLpromotor$CpG # Anzeigen aller Daten unter der Spalte "CpG" (Spalten hinter "$" ausw�hlbar)
ALLpromotor[,"CpG"] # Anzeigen der Spalte "CpG" mit allen Zeilen (�quivalent zu "$")
ALLpromotor[,3] # Anzeige der 3. Spalte mit allen Zeilen (�quivalent zu "$")
ALLpromotor[3,] # Anzeige der 3. Zeile mit allen Spalten
ALLpromotor[3,"CpG"] # Anzeigen des Wertes der Spalte "CpG" in Zeile 3
ALLpromotor[1,c(1,2,3)] # Anzeige der Daten der Spalten 1-3 in Zeile 1
ALLpromotor[c(1,2,4),c(1,5)] # Anzeigen der Daten der Spalten 1 und 5 mit den Zeilen 1,2 und 4

ALLpromotor$symbol <- NULL # Setzt alle Werte in Spalte "symbol" auf 0, woraufhin sie aus dem Datensatz gel�scht werden (gleiches Verfahren bei "entrezID", "GC", "C", "G", "Strand")

ALLpromotor[,c(5,6,7,8,9)] -> ALLhealthy          # Zusammenfassen aller gesunden Patienten-beta-daten in einer Matrix   
ALLpromotor[,c(10,11,12,13,14)] -> ALLdisease     # Zusammenfassen aller kranken Patienten-beta-daten in einer Matrix
ALLpromotor[,c(15,16,17,18,19)] -> ALLhealthyCov  # Zusammenfassen aller gesunden Patienten-coverage-daten in einer Matrix
ALLpromotor[,c(20,21,22,23,24)] -> ALLdiseaseCov  # Zusammenfassen aller kranken Patienten-coverage-daten in einer Matrix
ALLpromotor[,c(-1,-2,-3,-4)] -> ALLpromotorOnly   # Daten ohne die ersten 4 Spalten
ALLpromotor[,c(15,16,17,18,19,20,21,22,23,24)] -> ALLpromotorCov # Nur die Coverage-daten

# NAs IDENTIFIZIEREN
rmv.rows # Gibt Anzahl der NAs in jeder Zeile wieder 
#rmv.rows = apply(dat, 1, function(x) {sum(is.na(x))})
rmv.rows[1:20] # Nummer NAs in ersten 20 Zeilen
which(rmv.rows > 0) # Alle Zeilen mit mehr als 0 NAs (summiert NAs bei der Ausgabe)

# HISTOGRAMM POLTTEN
hist(ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage, xlab = "X-Achsenbeschriftung", ylab = "Y-Achsenbeschriftung", xlim = c(0,15000), ylim = c(0,4000), main = "Gesamt�berschrift", breaks = 2000) # xlim, ylim: Achsenskalierung; breaks: Anzahl Balken
abline(v = summary(ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage)[2:5], col = c("blue", "red", "black", "orange"), lty = 2) # Histogrammlinien (nicht ganz sicher was in [] und welche Farbe welche Linie)
abline(v = median(ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage), col = "black", lwd = 2) # Linie in Histogram f�r Median, lwd = Dicke der Linie

density(ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage) # Ausgabe der Quantile, sowie Median, Mean
plot((ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage), lwd = 1, col = "red", ylim = c(0,30000)) # Kommischer Punkteplot
plot(density(ALLhealthyCov$Bcell_gc_TO_G201.bed_coverage), xlim = c(0,20000)) # Normale Dichteverteilung

# DATEN ZUSAMMENFASSEN
install.packages("dplyr") # Gute Befehle enthalten
install.packages("tidye")
library(dplyr) # In R einbinden
library(tidyr)

# Plotten der Coverage mit zusammengefassten Patienten
rowMeans(ALLpromotor) # Durchschnitt der Zeilen
rowMeans(ALLpromotorCov) -> ALLCovMeans
hist(rowMeans(ALLpromotorCov), xlab = , ylab = "Number", xlim = c(0,10000), ylim = c(0,4000),breaks = 1000, lwd = 1, col = "orange") 
plot(density(rowMeans(ALLpromotorCov)), xlim = c(0,10000)) # Dichteverteilung
abline(v = median(rowMeans(ALLpromotorCov)), lwd = 2, col = "blue") # Markierung wo Median und Mean
abline(v = mean(rowMeans(ALLpromotorCov)), lwd = 2, col = "red")
legend(x = "topright", c("Mean", "Median"), col = c("red", "blue"), lwd = c(2,2)) # Legende f�r Linien

# Daten filtern (hier erst einmal alle Coverages �ber 8000)
Cov.remove = which(ALLpromotorCov > 8000) # Alle Werte gr��er 8000 in Cov.remove speichern
ALLpromotorCov0 = ALLpromotorCov[-Cov.remove, ] # Neue Liste ALLpromotorCov0 enth�lt alle Coveragewerte aus ALLpromotorCov abz�glicher den >8000
summary(ALLpromotorCov0) # Anzeigen Min/Max/Mean/qt.. etc
rowMeans(ALLpromotorCov0) -> ALLCovMeans0
  # Gehofft n f�r das Konfidenzintervall zu verkleinern L�schen der Daten bewirkte Verschiebung der Dimensionen

# Threshold setzen/ Intervall bestimmen (95%)
length(ALLCovMeans0)
leftborder <- mean(ALLCovMeans0)-1.96*(sd(ALLCovMeans0)/sqrt(length(ALLCovMeans0)))  # Berechnung linker Grenze
rightborder <- mean(ALLCovMeans0)+1.96*(sd(ALLCovMeans0)/sqrt(length(ALLCovMeans0))) # Berechnung rechter Grenze
  # F�r n = 53710: [1340;1361]
  # F�r n = 8000 : [-1078;3778]
  # Da 3.Qt nun bei 1899, Grenze auf 4000 (Falsch da Dimensionen verschoben)

# Coverages >8000 = NA setzen (bessere Alternative)
ALLpromotorCov1 <- replace(ALLpromotorCov, ALLpromotorCov == "8000", "NA")
  # Da nur ein Wert ersetzt, mit Schleife versuche aber dauert zu lange

