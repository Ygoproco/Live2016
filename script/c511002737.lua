--CH キング・アーサー
function c511002737.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(511001265)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511002737.damcon)
	e1:SetCost(c511002737.damcost)
	e1:SetTarget(c511002737.damtg)
	e1:SetOperation(c511002737.damop)
	c:RegisterEffect(e1)
	if not c511002737.global_check then
		c511002737.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c511002737.atkchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511002737.atkchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end
function c511002737.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:GetAttack()~=val
end
function c511002737.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511002737.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local dam=0
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	if c:GetAttack()>val then dam=c:GetAttack()-val
	else dam=val-c:GetAttack() end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c511002737.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
