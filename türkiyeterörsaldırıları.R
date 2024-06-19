install.packages(c("fansi", "utf8", "pkgconfig", "withr", "cli", "generics", "glue", "lifecycle", "magrittr", "pillar", "R6", "rlang", "tibble", "tidyselect", "vctrs"))
install.packages("dplyr", repos = "https://cloud.r-project.org/")
install.packages("ggplot2", repos = "https://cloud.r-project.org/")
install.packages("leaflet", repos = "https://cloud.r-project.org/")
install.packages("sf", repos = "https://cloud.r-project.org/")

# Kütüphaneleri yükleme
install.packages("dplyr")
install.packages("ggplot2")
install.packages("leaflet")
install.packages("sf")

# Kütüphaneleri yükleyip kullanma
library(dplyr)
library(ggplot2)
library(leaflet)
library(sf)

# Gerekli kütüphaneleri yükleme
library(dplyr)
library(ggplot2)

# Örnek veri seti oluşturma
# Türkiye sınırları içinde rastgele enlem ve boylam değerleri oluşturma
latitude_tr <- runif(1000, 36.0, 42.1)
longitude_tr <- runif(1000, 26.0, 45.5)

# Örnek veri seti oluşturma
gtd_data_tr <- data.frame(
  iyear = sample(2000:2020, 1000, replace = TRUE), # 2000-2020 yılları arasında rastgele yıllar
  attacktype1_txt = sample(c("Bombing/Explosion", "Armed Assault", "Assassination", "Hostage Taking"), 1000, replace = TRUE),
  latitude = latitude_tr,
  longitude = longitude_tr
)

# Yıllara göre saldırı sayısını hesaplama
yearly_attacks_tr <- gtd_data_tr %>%
  group_by(iyear) %>%
  summarize(count = n())

# Yıllara göre saldırı trendlerini görselleştirme
library(ggplot2)
ggplot(yearly_attacks_tr, aes(x = iyear, y = count)) +
  geom_line(color = "blue") +
  labs(title = "Türkiye'de Yıllara Göre Terör Saldırısı Trendleri", x = "Yıl", y = "Saldırı Sayısı") +
  theme_minimal()
# Harita görselleştirmesi için leaflet paketini kullanma
library(leaflet)

# Türkiye haritası
turkey_map <- leaflet() %>%
  setView(lng = 35.1686, lat = 39.0639, zoom = 6) %>%
  addTiles()  

# Noktaları haritaya ekleme
turkey_map <- turkey_map %>%
  addCircleMarkers(lng = gtd_data_tr$longitude, lat = gtd_data_tr$latitude,
                   radius = 3, color = "red", fillOpacity = 0.8)

# Haritayı görüntüleme
turkey_map

# Saldırı türlerine göre dağılım analizi
attack_type_counts <- gtd_data_tr %>%
  group_by(attacktype1_txt) %>%
  summarize(count = n()) %>%
  arrange(desc(count))  

# Saldırı türleri dağılımını görselleştirme
ggplot(attack_type_counts, aes(x = reorder(attacktype1_txt, -count), y = count)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  coord_flip() +  
  labs(title = "Türkiye'de Terör Saldırılarına Göre Saldırı Türleri Dağılımı",
       x = "Saldırı Türü", y = "Saldırı Sayısı") +
  theme_minimal()


