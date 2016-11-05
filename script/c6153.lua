--ＳＲドミノバタフライ
--Speedroid Domino Butterfly
--Scripted by Eerie Code
function c6153.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c6153.splimit)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6153,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,6153)
	e2:SetCost(c6153.thcost)
	e2:SetTarget(c6153.thtg)
	e2:SetOperation(c6153.thop)
	c:RegisterEffect(e2)
	--Synchro Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c6153.synlimit)
	c:RegisterEffect(e3)
	--Banish
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(LOCATION_REMOVED)
	e4:SetCondition(c6153.rmcon)
	c:RegisterEffect(e4)
end

function c6153.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsAttribute(ATTRIBUTE_WIND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c6153.thcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsDiscardable()
end
function c6153.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6153.thcfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c6153.thcfil,1,1,REASON_COST+REASON_DISCARD)
end
function c6153.thfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function c6153.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6153.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6153.thfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c6153.thfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c6153.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c6153.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WIND) or not c:IsRace(RACE_DRAGON+RACE_MACHINE)
end

function c6153.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
