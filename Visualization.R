library(magrittr)
library(dplyr)
library(gridExtra)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(corrplot)
library(ggcorrplot)
library(scales)
library(ggmap)

bank = read.csv("BankChurners.csv")

Attrited = subset(bank, bank$Attrition_Flag == "Attrited Customer")
Existing = subset(bank, bank$Attrition_Flag == "Existing Customer")

#Counts categorial data 

#Cutomer statues by Income 
#Chnge the order of the factor
bank$Income_Category= factor(bank$Income_Category, ordered=TRUE, levels=c("$120K +", "$80K - $120K", "$60K - $80K", "$40K - $60K", "Less than $40K", "Unknown"))


ggplot(bank, aes(y=Income_Category))+geom_bar(aes(fill = Attrition_Flag),position = "dodge")+theme_minimal()+ theme_classic()  +xlab("Count") + ylab("Income Category") + ggtitle(" Customer Status by Income" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")


inco=table(Existing$Income_Category)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Existing People Income",col = terrain.colors(length(x)))
legend("topright", c("$120K +","$80K - $120K","$60K - $80K","$40K - $60K","Less than $40K","Unkown"),
       fill = terrain.colors(length(x)))

#Cutomer statues by Marital Status 
bank$Marital_Status= factor(bank$Marital_Status, ordered=TRUE, levels=c("Married", "Single", "Unknown", "Divorced"))
ggplot(bank, aes(y=Marital_Status))+geom_bar(aes(fill =Attrition_Flag),position = "dodge")+theme_minimal()+ theme_classic()  +xlab("Count") + ylab("Marital Status") + ggtitle(" Customer Status by Marital Status" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")


inco=table(Existing$Marital_Status)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Existing People Marital Status",col = terrain.colors(length(x)))
legend("topright", c("Divorced","Married","Single","Unkown"),
       fill = terrain.colors(length(x)))

#Cutomer statues by Education Level 
bank$Education_Level= factor(bank$Education_Level, ordered=TRUE, levels=c("Uneducated","High School","College","Graduate","Post-Graduate","Doctorate", "Unknown"))
ggplot(bank, aes(y=Education_Level))+geom_bar(aes(fill =Attrition_Flag),position = "dodge")+theme_minimal()+ theme_classic()  +xlab("Count") + ylab("Education Level") + ggtitle("Customer Status by Education Level" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")


inco=table(Existing$Education_Level)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Existing People Education Level",col = terrain.colors(length(x)))
legend("topright", c("College","Doctorate","Graduate","High School","Post-Graduate","	Uneducated","Unkown"),
       fill = terrain.colors(length(x)))



#Cutomer statues by Card Category 
bank$Card_Category = factor(bank$Card_Category, ordered=TRUE, levels=c("Blue", "Silver", "Gold", "Platinum"))
ggplot(bank, aes(x=Card_Category))+geom_bar(aes(fill =Attrition_Flag),position = "dodge")+theme_minimal()+ theme_classic()  +xlab("Card Category") + ylab("Count") + ggtitle("Customer Status by Card Category" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")


inco=table(Attrited$Card_Category)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Attrited People Card Category",col = terrain.colors(length(x)))
legend("topright", c("Blue","Gold","Platinum","Silver"),
       fill = terrain.colors(length(x)))


#Cutomer statues by Gender 
ggplot(bank, aes(x=Gender))+geom_bar(aes(fill =Attrition_Flag),position = "dodge")+theme_minimal()+ theme_classic()  +xlab("Gender") + ylab("Count") + ggtitle("Customer Status by Gender" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")


inco=table(Existing$Gender)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Existing People Gender",col = terrain.colors(length(x)))
legend("topright", c("Female","Male"),
       fill = terrain.colors(length(x)))


#Cutomer statues by number of dependents
bank$Dependent_count = as.factor(as.character(bank$Dependent_count))
ggplot(bank, aes(x=Dependent_count))+geom_bar(aes(fill =Attrition_Flag),position = "dodge")+ theme_classic() +xlab("Dependent count") + ylab("Count") + ggtitle("Customer Status by Dependent count" )+  labs(fill = "Customer Status")+ scale_fill_brewer(palette="Greens")

inco=table(Existing$Dependent_count)
inco=as.data.frame(inco)
x = inco$Freq
piepercent<- round(100*x/sum(x), 1)

pie(x, labels = piepercent, main = "Existing People Dependent count",col = terrain.colors(length(x)))
legend("topright", c("0","1","2","3","4","	5"),
       fill = terrain.colors(length(x)))



#----------------------------
# Distributions of numerical data 
bank %>%keep(is.numeric) %>%gather() %>%ggplot() + geom_histogram(mapping = aes(x=value,fill=key), color="black") +facet_wrap(~ key, scales = "free") +  theme_minimal() +theme(legend.position = 'none')
# Age 

g2= bank %>%ggplot( aes(x=Customer_Age, fill=Attrition_Flag)) +geom_density(alpha=0.6)+theme_classic() +geom_vline(aes(xintercept=mean(Customer_Age)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Customer Age Hisogram by Customer Statues") +xlab("Customer Age")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g22 = ggplot(bank, aes(x = Attrition_Flag, y = Customer_Age, fill = Attrition_Flag))+theme_classic() +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g2,g22,ncol=1,nrow=2)


g3=bank %>%ggplot( aes(x=Total_Trans_Ct, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Total_Trans_Ct)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Total Transaction count by Customer Statues") +xlab("Total Transaction count")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g33 = ggplot(bank, aes(x = Attrition_Flag, y = Total_Trans_Ct, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g3,g33,ncol=1,nrow=2)


g4=bank %>%ggplot( aes(x=Total_Ct_Chng_Q4_Q1, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Total_Ct_Chng_Q4_Q1)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Total count change Hisogram by Customer Statues") +xlab("Total count change")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g44 = ggplot(bank, aes(x = Attrition_Flag, y = Total_Ct_Chng_Q4_Q1, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g4,g44,ncol=1,nrow=2)



g5=bank %>%ggplot( aes(x=Total_Revolving_Bal, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Total_Revolving_Bal)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Total revolving balance Hisogram by Customer Statues") +xlab("total revolving balance")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g55 = ggplot(bank, aes(x = Attrition_Flag, y = Total_Revolving_Bal, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g5,g55,ncol=1,nrow=2)



g6=bank %>%ggplot( aes(x=Avg_Utilization_Ratio, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Avg_Utilization_Ratio)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Average utilization ratio Hisogram by Customer Statues") +xlab("average utilization ratio")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g66 = ggplot(bank, aes(x = Attrition_Flag, y = Avg_Utilization_Ratio, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g6,g66,ncol=1,nrow=2)


g7=bank %>%ggplot( aes(x=Credit_Limit, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Credit_Limit)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Credit limit Hisogram by Customer Statues") +xlab("Credit limit")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g77 = ggplot(bank, aes(x = Attrition_Flag, y = Credit_Limit, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g7,g77,ncol=1,nrow=2)


g8=bank %>%ggplot( aes(x=Total_Trans_Amt, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Total_Trans_Amt)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Total Transaction amount Hisogram by Customer Statues") +xlab("Total Transaction amount")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g88 = ggplot(bank, aes(x = Attrition_Flag, y = Total_Trans_Amt, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g8,g88,ncol=1,nrow=2)

g9=bank %>%ggplot( aes(x=Months_on_book, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Months_on_book)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Months_on_book Hisogram by Customer Statues") +xlab("Months_on_book")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g99 = ggplot(bank, aes(x = Attrition_Flag, y = Months_on_book, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g9,g99,ncol=1,nrow=2)


g10=bank %>%ggplot( aes(x=Total_Relationship_Count, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Total_Relationship_Count)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Total_Relationship_Count Hisogram by Customer Statues") +xlab("Total_Relationship_Count")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g100 = ggplot(bank, aes(x = Attrition_Flag, y = Total_Relationship_Count, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g10,g100,ncol=1,nrow=2)


g10=bank %>%ggplot( aes(x=Months_Inactive_12_mon, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Months_Inactive_12_mon)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Months_Inactive_12_mon Hisogram by Customer Statues") +xlab("Months_Inactive_12_mon")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g100 = ggplot(bank, aes(x = Attrition_Flag, y = Months_Inactive_12_mon, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g10,g100,ncol=1,nrow=2)

g10=bank %>%ggplot( aes(x=Contacts_Count_12_mon, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Contacts_Count_12_mon)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Contacts_Count_12_mon Hisogram by Customer Statues") +xlab("Contacts_Count_12_mon")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g100 = ggplot(bank, aes(x = Attrition_Flag, y = Contacts_Count_12_mon, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g10,g100,ncol=1,nrow=2)


g10=bank %>%ggplot( aes(x=Avg_Open_To_Buy, fill=Attrition_Flag)) +geom_density(alpha=0.6) +geom_vline(aes(xintercept=mean(Avg_Open_To_Buy)),color="black", linetype="dashed", size=1)+theme_light() + scale_fill_manual(values = c("red", "seagreen3"))+ggtitle("Avg_Open_To_Buy Hisogram by Customer Statues") +xlab("Avg_Open_To_Buy")+ylab("Frequency")+ theme(plot.title = element_text(size=15))  
g100 = ggplot(bank, aes(x = Attrition_Flag, y = Avg_Open_To_Buy, fill = Attrition_Flag)) +geom_boxplot() + theme_light() +theme(legend.position = 'none') + scale_fill_manual(values = c("red", "seagreen3"))
grid.arrange(g10,g100,ncol=1,nrow=2)


bank2 = bank  
bank2$Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Count_12_mon_Dependent_count_Education_Level_Months_Inactive_12_mon_2 =NULL
bank2$Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Count_12_mon_Dependent_count_Education_Level_Months_Inactive_12_mon_1= NULL
bank2$CLIENTNUM=NULL
numericVarName = names(which(sapply(bank2, is.numeric)))
corr = cor(bank2[,numericVarName], use = 'pairwise.complete.obs')
corr = corr
cory=cor_pmat(corr)
ggcorrplot(corr , type="upper",hc.order = TRUE,outline.col = "white", p.mat = cory, colors = c("#66CC75", "white", "red"))

df_num = select_if(bank2,is.numeric)
df_num = data.frame(lapply(df_num, function(x) as.numeric(as.character(x))))
res=cor(df_num)
corrplot(res, type="upper", tl.col="#636363",tl.cex=0.5 )

  
