--十二獣ブルホーン
--Juunishishi Bullhorn
--Scripted by Eerie Code
function c85115440.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,c85115440.ovfilter,aux.Stringid(85115440,0),2,c85115440.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c85115440.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c85115440.defval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85115440,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c85115440.thcost)
	e3:SetTarget(c85115440.thtg)
	e3:SetOperation(c85115440.thop)
	c:RegisterEffect(e3)
end

function c85115440.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(85115440)
end
function c85115440.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,85115440)==0 end
  Duel.RegisterFlagEffect(tp,85115440,RESET_PHASE+PHASE_END,0,1)
end

function c85115440.adfil(c)
	return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER)
end
function c85115440.atkval(e,c)
	return c:GetOverlayGroup():Filter(c85115440.adfil,nil):Filter(Card.IsAttackAbove,nil,1):GetSum(Card.GetAttack)
end
function c85115440.defval(e,c)
	return c:GetOverlayGroup():Filter(c85115440.adfil,nil):Filter(Card.IsDefenseAbove,nil,1):GetSum(Card.GetDefense)
end

function c85115440.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85115440.thfil(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c85115440.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85115440.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c85115440.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c85115440.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
