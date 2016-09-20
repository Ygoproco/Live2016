--Number 2: Numeron Gate Dve
function c511000231.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c511000231.valcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c511000231.con)
	e2:SetCost(c511000231.cost)
	e2:SetTarget(c511000231.tg)
	e2:SetOperation(c511000231.op)
	c:RegisterEffect(e2)
end
c511000231.xyz_number=2
function c511000231.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c511000231.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c511000231.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000231.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1ff)
end
function c511000231.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000231.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c511000231.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511000231.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
