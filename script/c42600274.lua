--Cyber Tutubon
function c42600274.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c42600274.spcon)
	e1:SetOperation(c42600274.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(c42600274.thcon)
	e2:SetTarget(c42600274.thtg)
	e2:SetOperation(c42600274.thop)
	c:RegisterEffect(e2)
end
function c42600274.filter(c)
	return c:IsRace(RACE_FAIRY+RACE_WARRIOR) and c:IsAbleToGrave() 
		and Duel.IsPlayerCanRelease(c:GetControler(), c) 
end
function c42600274.spcon(e,c)
	if c==nil then return true end
	local num=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local zone=LOCATION_HAND+LOCATION_MZONE
	if num==0 then zone=LOCATION_MZONE end
	return num>=0 and Duel.IsExistingMatchingCard(c42600274.filter,c:GetControler(),zone,0,1,c)
end
function c42600274.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local num=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	if num<0 then return end 
	local zone=LOCATION_HAND+LOCATION_MZONE
	if num==0 then zone=LOCATION_MZONE end
	local g=Duel.SelectMatchingCard(tp,c42600274.filter,tp,zone,0,1,1,c)
	Duel.Release(g,REASON_COST)
end

function c42600274.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RITUAL)
end
function c42600274.thfilter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function c42600274.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c42600274.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c42600274.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c42600274.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c42600274.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
