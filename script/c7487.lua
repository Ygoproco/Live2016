--SPYRAL Master Plan
--Scripted by Eerie Code
function c7487.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7487,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c7487.thtg1)
	e1:SetOperation(c7487.thop1)
	c:RegisterEffect(e1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7487,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,7487)
	e5:SetCondition(c7487.thcon2)
	e5:SetTarget(c7487.thtg2)
	e5:SetOperation(c7487.thop2)
	c:RegisterEffect(e5)
end

function c7487.thfil1(c)
	return c:IsSetCard(0x20ee) and c:IsAbleToHand()
end
function c7487.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7487.thfil1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7487.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7487.thfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c7487.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c7487.thfil2(c)
	return c:IsCode(7488) and c:IsAbleToHand()
end
function c7487.thfil3(c)
	return c:IsSetCard(0xee) and c:IsType(TYPE_MONSTER) and not c:IsCode(7487) and c:IsAbleToHand()
end
function c7487.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7487.thfil2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c7487.thfil3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c7487.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c7487.thfil2,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c7487.thfil3,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
