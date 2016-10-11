--混沌の使者
--Envoy of Chaos
--Scripted by Eerie Code
function c38695361.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38695361,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c38695361.atkcon)
	e1:SetCost(c38695361.atkcost)
	e1:SetTarget(c38695361.atktg)
	e1:SetOperation(c38695361.atkop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38695361,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c38695361.thcost)
	e2:SetTarget(c38695361.thtg)
	e2:SetOperation(c38695361.thop)
	c:RegisterEffect(e2)
end

function c38695361.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c38695361.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c38695361.atkfil(c)
	return c:IsFaceup() and (c:IsSetCard(0xbd) or c:IsSetCard(0x10cf))
end
function c38695361.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c38695361.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c38695361.atkfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c38695361.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c38695361.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	tc:RegisterFlagEffect(38695361,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c38695361.atkcon2)
	e2:SetTarget(c38695361.atktg2)
	e2:SetValue(c38695361.atkval)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c38695361.atkcon2(e)
	local tc=e:GetLabelObject()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and tc:GetFlagEffect(38695361)~=0 and tc:GetBattleTarget()
end
function c38695361.atktg2(e,c)
	return c==e:GetLabelObject():GetBattleTarget()
end
function c38695361.atkval(e,c)
	return c:GetBaseAttack()
end

function c38695361.thcfil(c,attr)
	return c:IsAttribute(attr) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c38695361.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c38695361.thcfil,tp,LOCATION_GRAVE,0,1,c,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c38695361.thcfil,tp,LOCATION_GRAVE,0,1,c,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c38695361.thcfil,tp,LOCATION_GRAVE,0,1,1,c,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c38695361.thcfil,tp,LOCATION_GRAVE,0,1,1,c,ATTRIBUTE_DARK)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c38695361.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c38695361.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
