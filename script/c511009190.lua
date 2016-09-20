--Fairy Powder
function c511009190.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511009190.target)
	e1:SetOperation(c511009190.operation)
	c:RegisterEffect(e1)
end
function c511009190.filter(c)
	return c:GetLevel()>0
end
function c511009190.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009190.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009190.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPDEFENSE)
	Duel.SelectTarget(tp,c511009190.filter,tp,LOCATION_MZONE,0,1,1,nil)
 end
function c511009190.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FAIRY)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BE_MATERIAL)
		e3:SetCondition(c511009190.effcon)
		e3:SetReset(RESET_EVENT+17e0000+RESET_PHASE+PHASE_END)
		e3:SetOperation(c511009190.effop)
		tc:RegisterEffect(e3)
	end
end

function c511009190.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsRace(RACE_FAIRY)
end
function c511009190.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,95100911)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(38331564,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511009190.atkcon)
	e1:SetOperation(c511009190.atkop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c511009190.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c511009190.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(66500065,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
