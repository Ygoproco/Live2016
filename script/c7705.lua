--E・HERO オネスティ・ネオス
--Elemental HERO Honesty Neos
--Scripted by Eerie Code
function c7705.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7705,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,7705)
	e1:SetCost(c7705.atkcost1)
	e1:SetTarget(c7705.atktg1)
	e1:SetOperation(c7705.atkop1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7705,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7705+1)
	e2:SetCost(c7705.atkcost2)
	e2:SetOperation(c7705.atkop2)
	c:RegisterEffect(e2)
end

function c7705.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c7705.atkfil(c)
	return c:IsFaceup() and c:IsSetCard(0x8)
end
function c7705.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7705.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7705.atkfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c7705.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7705.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c7705.cfilter(c)
	return c:IsSetCard(0x8) and c:GetAttack()>0 and c:IsDiscardable()
end
function c7705.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7705.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c7705.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c7705.atkop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local atk=math.max(tc:GetAttack(),0)
	if c:IsRelateToBattle() and c:IsFaceup() and c:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end