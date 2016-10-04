--Flames of the Archfiend
function c511002433.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511002433.condition)
	e1:SetTarget(c511002433.target)
	e1:SetOperation(c511002433.activate)
	c:RegisterEffect(e1)
end
function c511002433.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x45)
end
function c511002433.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002433.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511002433.desfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x45) and c:IsAttackBelow(1000)
end
function c511002433.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local c2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	if chk==0 then return (c1 and c1:IsDestructable()) or (c2 and c2:IsDestructable()) 
		or Duel.IsExistingMatchingCard(c511002433.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Group.CreateGroup()
	if c1 and c1:IsDestructable() then g:AddCard(c1) end
	if c2 and c2:IsDestructable() then g:AddCard(c2) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local sg=Duel.GetMatchingGroup(c511002433.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function c511002433.activate(e,tp,eg,ep,ev,re,r,rp)
	local c1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local c2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	local g=Group.CreateGroup()
	if c1 and c1:IsDestructable() then g:AddCard(c1) end
	if c2 and c2:IsDestructable() then g:AddCard(c2) end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(c511002433.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
