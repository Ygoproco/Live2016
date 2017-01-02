--ブリザード・ファルコン
function c511002546.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(511002546)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511002546.damcon)
	e1:SetTarget(c511002546.damtg)
	e1:SetOperation(c511002546.damop)
	c:RegisterEffect(e1)
	if not c511002546.global_check then
		c511002546.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c511002546.atkchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511002546.atkchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end
function c511002546.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:GetAttack()~=val
end
function c511002546.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local atk=0
	if c:GetBaseAttack()>=c:GetAttack() then
		atk=c:GetBaseAttack()-c:GetAttack()
	else
		atk=c:GetAttack()-c:GetBaseAttack()
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c511002546.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local atk=0
	if c:GetBaseAttack()>=c:GetAttack() then
		atk=c:GetBaseAttack()-c:GetAttack()
	else
		atk=c:GetAttack()-c:GetBaseAttack()
	end
	Duel.Damage(p,atk,REASON_EFFECT)
end
