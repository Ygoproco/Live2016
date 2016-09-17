--Scripted by Eerie Code
--Thorn Over Server - Van Darli Zuma
function c700000033.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,700000030,700000031,700000032,true,true)
	--Atk update
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c700000033.atkval)
	c:RegisterEffect(e1)
	--ATK to 100
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c700000033.cost)
	e2:SetTarget(c700000033.target)
	e2:SetOperation(c700000033.operation)
	c:RegisterEffect(e2)
end

function c700000033.atkval(e,c)
	local cont=c:GetControler()
	local atk=2500-Duel.GetLP(cont)
	if atk<0 then atk=0 end
	return atk*2
end

function c700000033.filter(c)
	--return c:IsFaceup() and not c:GetAttack()==100
	if c:IsFacedown() then 
		--Debug.Message("Target facedown.")
		return false
	end
	if c:GetAttack()==100 then
		--Debug.Message("ATK equal to 100.")
		return false
	end
	return true
end
function c700000033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
function c700000033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c700000033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c700000033.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,c700000033.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c700000033.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end