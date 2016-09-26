--十二獣ドランシア
--Juunishishi Drancia
--Scripted by Eerie Code
function c7551.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,c7551.ovfilter,aux.Stringid(7551,0),4,c7551.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c7551.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c7551.defval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7551,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1)
	e3:SetCost(c7551.thcost)
	e3:SetOperation(c7551.thop)
	c:RegisterEffect(e3)
end

function c7551.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2) and not c:IsCode(7551)
end
function c7551.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,7551)==0 end
  Duel.RegisterFlagEffect(tp,7551,RESET_PHASE+PHASE_END,0,1)
end

function c7551.adfil(c)
	return c:IsSetCard(0xf2) and c:IsType(TYPE_MONSTER)
end
function c7551.adfil2(c)
	return c:IsSetCard(0xf2) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function c7551.atkval(e,c)
	return c:GetOverlayGroup():Filter(c7551.adfil,nil):GetSum(Card.GetAttack)-c:GetOverlayGroup():Filter(c7551.adfil2,nil):GetSum(Card.GetAttack)
end
function c7551.defval(e,c)
	return c:GetOverlayGroup():Filter(c7551.adfil,nil):GetSum(Card.GetDefense)-c:GetOverlayGroup():Filter(c7551.adfil2,nil):GetSum(Card.GetDefense)
end

function c7551.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.IsExistingMatchingCard(c7551.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7551.thfil(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToHand() and c:IsSummonableCard()
end
function c7551.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c7551.thfil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end